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
        register { PokeApiPokemonState() }.scope(shared)
        register { Cache.loadCache(withName: Constants.cacheFileNames.Pokemon) ?? Cache<String,Pokemon>() }.scope(shared)
        register { Cache.loadCache(withName: Constants.cacheFileNames.PokemonSprites) ?? Cache<String,Data>() }.scope(shared)
        register { Cache.loadCache(withName: Constants.cacheFileNames.PokemonList) ?? Cache<Int,[NamedApiResponse]>() }.scope(shared)
    }
}
