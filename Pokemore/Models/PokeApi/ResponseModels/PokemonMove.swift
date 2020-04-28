//
//  PokemonMove.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/26.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
struct PokemonMove : Codable {
    let move: NamedApiResponse
    let versionGroupDetails: [Move]
    
    private enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}
