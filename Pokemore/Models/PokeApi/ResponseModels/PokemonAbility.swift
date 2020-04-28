//
//  PokemonAbility.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/24.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
struct PokemonAbility : Codable {
    var ability: NamedApiResponse
    var isHidden: Bool
    var slot: Int
    
    private enum CodingKeys: String, CodingKey {
        case ability, slot
        case isHidden = "is_hidden"
    }
}
