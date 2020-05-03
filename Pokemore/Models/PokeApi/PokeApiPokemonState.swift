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
    @Injected var pokemonListState: Cache<Int,[NamedApiResponse]> //Store pages of pokemon list TODO: Add additional scrolling with pages
    @Injected var pokemonState: Cache<String,Pokemon>
    @Injected var pokemonSprites: Cache<String,Data>
    
    func updateListState(tillIndex index: Int) {
        PokeApi.GetPokemonList(withOffset: 0, limit: index, onError: { error in
            print(error ?? "")
            //TODO: Do something on error
        }){ pokemonResponse in
            self.pokemonListState[0] = pokemonResponse.results
            self.listDelegate?.onPokemonListUpdated(pokemonResponse.results)
            self.prefetchPokemonFromList(at: 0)
        }
    }
    
    func prefetchPokemonFromList(at index: Int) {
        guard let list = self.pokemonListState[index] else{
            return
        }
        prefetchPokemonSprites(for: list)
        prefetchPokemon(for: Array(list.prefix(5))) // Prefetch the first 5
    }
    
    func prefetchPokemonSprites(for list: [NamedApiResponse]) {
        for i in 0 ..< list.count {
            let pokemon = list[i]
            PokeApi.GetPokemonSprite(at:  pokemon.url, onError: { (error) in
                print(error ?? "") //TODO: Do something meaningful with error
            }){ data in
                self.pokemonSprites[pokemon.name] = data
                self.delegate?.onPokemonSpriteUpdated(sprite: data)
                self.listDelegate?.onRowUpdate(at: i)
            }
        }
    }
    
    func prefetchPokemon(for list: [NamedApiResponse]) {
        for pokemon in list {
            PokeApi.GetPokemon(at: pokemon.url, onError: { (error) in
                print(error ?? "") //TODO: Do something meaningful with error
            }) { (pokemon) in
                self.pokemonState[pokemon.name] = pokemon
                self.delegate?.onPokemonUpdated(pokemon: pokemon)
            }
        }
    }
    
    func prefetchPokemon(atUrl url: String, name: String, index: Int) -> Void {
        if self.pokemonState[name] == nil {
            PokeApi.GetPokemon(at: url, onError: { (error) in
                print(error ?? "") //TODO: Do something meaningful with error
            }) { (pokemon) in
                self.pokemonState[name] = pokemon
                self.delegate?.onPokemonUpdated(pokemon: pokemon)
                self.listDelegate?.onRowUpdate(at: index)
            }
        }
        if self.pokemonSprites[name] == nil {
            PokeApi.GetPokemonSprite(at:  url, onError: { (error) in
                print(error ?? "") //TODO: Do something meaningful with error
            }){ data in
                self.pokemonSprites[name] = data
                self.delegate?.onPokemonSpriteUpdated(sprite: data)
                self.listDelegate?.onRowUpdate(at: index)
            }
        }
    }
    
    func persistCache() {
        try? pokemonListState.persistCache(withName: Constants.cacheFileNames.PokemonList)
        try? pokemonState.persistCache(withName: Constants.cacheFileNames.Pokemon)
        try? pokemonSprites.persistCache(withName: Constants.cacheFileNames.PokemonSprites)
    }
    
    func getPokemonById(at name: String) -> Pokemon? {
        return pokemonState[name]
    }
    
    func getPokemonSpriteById(at name: String) -> Data? {
        return pokemonSprites[name]
    }
    
    func getCurrentListState() -> [NamedApiResponse] {
        guard let result = self.pokemonListState[0] else {
            updateListState(tillIndex: Constants.PokemonList.listSize)
            return [NamedApiResponse]()
        }
        return result
    }
}


