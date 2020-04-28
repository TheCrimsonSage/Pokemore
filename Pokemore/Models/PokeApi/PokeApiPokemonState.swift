//
//  PokeApiState.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/18.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

protocol PokeApiPokemonStateDelegate {
    func onPokemonUpdated(pokemon: Pokemon)
    func onPokemonSpriteUpdated(sprite: Data)
}
protocol PokeApiListStateDelegate {
    func onRowUpdate(at position: Int)
    func onPokemonListUpdated(_ list: [NamedApiResponse])
}

class PokeApiPokemonState {
    var delegate: PokeApiPokemonStateDelegate?
    var listDelegate: PokeApiListStateDelegate?
    var pokemonListState: Cache<Int,[NamedApiResponse]>
        = Cache.loadCache(withName: Constants.cacheFileNames.PokemonList) ?? Cache<Int,[NamedApiResponse]>() //Store pages of pokemon list TODO: Add additional scrolling with pages
    var pokemonState: Cache<String,Pokemon> = Cache.loadCache(withName: Constants.cacheFileNames.Pokemon) ?? Cache<String,Pokemon>()
    var pokemonSprites: Cache<String,Data> = Cache.loadCache(withName: Constants.cacheFileNames.PokemonSprites) ?? Cache<String,Data>()
    let concurrencyControl = ConcurrencyControl(id: "com.jasoncloete.pokemore.pokeapi.pokestate")

    init() {
    }
    
    func updateListState(tillIndex: Int) {
        PokeApi.GetPokemonList(withOffset: 0, limit: 400, onError: { error in
            print(error ?? "")
            //TODO: Do something on error
        }){ pokemonResponse in
            self.concurrencyControl.exclusivelyWrite {
                self.pokemonListState[0] = pokemonResponse.results
                self.listDelegate?.onPokemonListUpdated(pokemonResponse.results)
                for i in 0..<pokemonResponse.results.count {
                    let pokemon = pokemonResponse.results[i]
                    PokeApi.GetPokemonSprite(at:  pokemon.url, onError: { (error) in
                        print(error ?? "") //TODO: Do something meaningful with error
                    }){ data in
                        self.concurrencyControl.exclusivelyWrite {
                            self.pokemonSprites[pokemon.name] = data
                        }
                        self.delegate?.onPokemonSpriteUpdated(sprite: data)
                        self.listDelegate?.onRowUpdate(at: i)
                    }
                }
                for pokemon in pokemonResponse.results.prefix(5) { // Prefetch the first 5
                    PokeApi.GetPokemon(at: pokemon.url, onError: { (error) in
                        print(error ?? "") //TODO: Do something meaningful with error
                    }) { (pokemon) in
                        self.concurrencyControl.exclusivelyWrite {
                            self.pokemonState[pokemon.name] = pokemon
                        }
                    }
                }
            }
        }
    }
    
    func prefetchPokemon(atUrl url: String, name: String, index: Int) -> Void {
        self.concurrencyControl.exclusivelyWrite {
            if self.pokemonState[name] == nil {
                PokeApi.GetPokemon(at: url, onError: { (error) in
                    print(error ?? "") //TODO: Do something meaningful with error
                }) { (pokemon) in
                    self.concurrencyControl.exclusivelyWrite {
                        self.pokemonState[name] = pokemon
                    }
                    self.delegate?.onPokemonUpdated(pokemon: pokemon)
                    self.listDelegate?.onRowUpdate(at: index)
                }
            }
            if self.pokemonSprites[name] == nil {
                PokeApi.GetPokemonSprite(at:  url, onError: { (error) in
                    print(error ?? "") //TODO: Do something meaningful with error
                }){ data in
                    self.concurrencyControl.exclusivelyWrite {
                        self.pokemonSprites[name] = data
                    }
                    self.delegate?.onPokemonSpriteUpdated(sprite: data)
                    self.listDelegate?.onRowUpdate(at: index)
                }
            }
        }
    }
    
    func persistCache() {
        try? pokemonListState.persistCache(withName: Constants.cacheFileNames.PokemonList)
        try? pokemonState.persistCache(withName: Constants.cacheFileNames.Pokemon)
        try? pokemonSprites.persistCache(withName: Constants.cacheFileNames.PokemonSprites)
    }
    
    func getPokemonById(at name: String) -> Pokemon? {
        var result: Pokemon?
        self.concurrencyControl.concurrentlyRead {
            result = pokemonState[name]
        }
        return result
    }
    
    func getPokemonSpriteById(at name: String) -> Data? {
        var result: Data?
        self.concurrencyControl.concurrentlyRead {
            result = pokemonSprites[name]
        }
        return result
    }
    
    func getCurrentListState() -> [NamedApiResponse] {
        var result: [NamedApiResponse]?
        self.concurrencyControl.concurrentlyRead {
            result = self.pokemonListState[0]
        }
        if result == nil {
            updateListState(tillIndex: 200)
        }
        return result ?? [NamedApiResponse]()
    }
}
