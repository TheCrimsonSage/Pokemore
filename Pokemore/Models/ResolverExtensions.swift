//
//  ResolverExtensions.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/27.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { PokeApiPokemonState() }
    }
}
