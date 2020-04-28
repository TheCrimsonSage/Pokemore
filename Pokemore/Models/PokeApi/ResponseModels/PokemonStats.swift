//
//  PokemonStats.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/26.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

struct PokemonStats : Codable {
    let baseStat: Int
    let effort: Int
    let stat: NamedApiResponse
    
    private enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseStat = "base_stat"
    }
}
