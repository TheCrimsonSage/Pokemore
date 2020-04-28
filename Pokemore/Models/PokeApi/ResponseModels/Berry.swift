//
//  Berry.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/18.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

struct Berry : Codable {
    let id: Int
    let name: String
    let growthTime: Int
    let maxHarvest: Int
    let naturalGiftPower: Int
    let size: Int
    let smoothness: Int
    let soilDryness: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, size, smoothness
        case growthTime = "growth_time"
        case maxHarvest = "max_harvest"
        case naturalGiftPower = "natural_gift_power"
        case soilDryness = "soil_dryness"
    }
}
