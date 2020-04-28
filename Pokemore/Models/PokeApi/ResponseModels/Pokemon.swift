//
//  Pokemon.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/18.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
struct Pokemon : Codable {
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let isDefault: Bool
    let order: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let moves: [PokemonMove]
    let species: NamedApiResponse
    let stats: [PokemonStats]

    private enum CodingKeys: String, CodingKey {
        case id, name, height, order, weight, abilities, moves, species, stats
        case baseExperience = "base_experience"
        case isDefault = "is_default"
    }
}
