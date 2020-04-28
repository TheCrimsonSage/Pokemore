//
//  PokemonResponse.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/18.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [NamedApiResponse]
}
