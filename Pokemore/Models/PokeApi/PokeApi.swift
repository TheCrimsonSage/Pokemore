//
//  PokeApi.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/16.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

class PokeApi {
    static let baseUrl = "https://pokeapi.co/api/v2/"
}

// MARK: Pokemon

extension PokeApi {
    
    static func GetPokemonList(withOffset offset: Int, limit: Int, onError: @escaping (Error?) -> Void, onResponse: @escaping (PokemonListResponse) -> Void) {
        Http.Get(url: "\(PokeApi.baseUrl)pokemon?offset=\(offset)&limit=\(limit)", onError: onError, onResponse:onResponse)
    }
    
    static func GetPokemon(at index: Int, onError: @escaping (Error?) -> Void, onResponse: @escaping (Pokemon) -> Void) {
        Http.Get(url: "\(PokeApi.baseUrl)pokemon/\(index)", onError: onError, onResponse:onResponse)
    }
    
    static func GetPokemon(at url: String, onError: @escaping (Error?) -> Void, onResponse: @escaping (Pokemon) -> Void) {
        Http.Get(url: url, onError: onError, onResponse:onResponse)
    }
    
    static func GetPokemonSprite(at fullUrl: String, onError: @escaping (Error?) -> Void, onResponse: @escaping (Data) -> Void) {
        var url = fullUrl.components(separatedBy: "/")
        if fullUrl.suffix(1) == "/" {
            url = url.dropLast()
        }
        if let id = url.last {
            Http.GetData(from: getPokemonSprite(for: id), onError: onError, onResponse: onResponse)
        }
    }
    
    static func getPokemonSprite(for id: String) -> String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/\(id).png"
    }
    
}
