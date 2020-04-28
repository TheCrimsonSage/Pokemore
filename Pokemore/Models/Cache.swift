//This code was adapted for use in this app, original code found here: https://www.swiftbysundell.com/articles/caching-in-swift/

import Foundation

struct CacheConstants {
    static let defaultCacheEntryLifetime = 12 * 60 * 60
    static let maximumEntries = 2000
}

final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()

    init(dateProvider: @escaping () -> Date = Date.init, //In case the data contains the date of validity of the data otherwise default -> current date
         entryLifetime: TimeInterval = TimeInterval(CacheConstants.defaultCacheEntryLifetime),
         maximumEntryCount: Int = CacheConstants.maximumEntries) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate = keyTracker
    }

    func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)
    }

    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }

        guard dateProvider() < entry.expirationDate else {
            // Discard values that have expired
            removeValue(forKey: key)
            return nil
        }

        return entry.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

//MARK: WrappedKey

private extension Cache {
    final class WrappedKey: NSObject { //We wrap the key so that the key doesn't have to inherit from the NSObject class
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}

//MARK: Entry

private extension Cache {
    final class Entry {
        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

//MARK: Usability extensions

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}

private extension Cache {
    func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }

        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }

        return entry
    }

    func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}

//MARK: Keytracker
//So that we can keep track of how many objects are in the cache and if any of them need to be evicted
private extension Cache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()

        func cache(_ cache: NSCache<AnyObject, AnyObject>,
                   willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }

            keys.remove(entry.key)
        }
    }
}

//MARK: Codable

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

extension Cache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

extension Cache where Key: Codable, Value: Codable {
    static func loadCache(
        withName name: String,
        using fileManager: FileManager = .default
    ) -> Cache?  {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        if let data = try? Data(contentsOf: fileURL) {
            if let res = try? JSONDecoder().decode(Cache.self, from: data) {
                return res;
            }
        }
        return nil;
    }
    
    func persistCache(
        withName name: String,
        using fileManager: FileManager = .default
    ) throws {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}
