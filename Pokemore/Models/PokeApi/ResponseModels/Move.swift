//
//  Move.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/26.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation
struct Move : Codable {
    let levelLearnedAt: Int
    let moveLearnMethod: NamedApiResponse
    let versionGroup: NamedApiResponse
    
    private enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}
