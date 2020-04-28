//
//  ConcurrencyControl.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/22.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
class ConcurrencyControl {
    let id: String
    private let queue: DispatchQueue

    public func concurrentlyRead<T>(_ block: (() throws -> T)) rethrows -> T {
        return try queue.sync {
            try block()
        }
    }
    
    public func concurrentlyRead(_ block: (() -> Void)) {
        return queue.sync {
            block()
        }
    }

    public func exclusivelyWrite(_ block: @escaping (() -> Void)) {
        queue.async(flags: .barrier) {
            block()
        }
    }
    
    init(id: String) {
        self.id = id
        queue = DispatchQueue(label: id, attributes: .concurrent)
    }
}
