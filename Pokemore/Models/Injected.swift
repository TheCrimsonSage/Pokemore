//
//  Injected.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/27.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
import Resolver

@propertyWrapper
struct Injected<Service> {
    public var service: Service?
    public var container: Resolver?
    public var name: String?
    public var wrappedValue: Service {
        mutating get {
            if service == nil {
                service = (container ?? Resolver.root).resolve(
                    Service.self,
                    name: name
                )
            }
            return service!
        }
        mutating set {
            service = newValue
        }
    }
    public var projectedValue: Injected<Service> {
        get {
            return self
        }
        mutating set {
            self = newValue
        }
    }
}
