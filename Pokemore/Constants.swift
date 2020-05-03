//
//  Constants.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/16.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

struct Constants{
    struct TableViewCell{
        static let MainMenuCellXib = "MainMenuItemTableViewCell"
        static let MainMenuCellIdentifier = "MainMenuItem"
        static let PokemonListCellXib = "PokemonListTableViewCell"
        static let PokemonListCellIdentifier = "PokemonListItem"
    }
    
    struct cacheFileNames {
        static let PokemonList = "pokemonList"
        static let Pokemon = "pokemon"
        static let PokemonSprites = "pokemonSprites"
    }
    
    struct PokemonList {
        static let listSize = 200
    }
    
    static let mainMenuItems = [
        MainMenuItem(name: "Pokémon", description: "All the different Pokémon", imageIdentifier: "pokeball", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Berries", description: "Berries are small fruits that can provide bonuses", imageIdentifier: "berries", segueIdentifier: "berryList"),
        MainMenuItem(name: "Contests", description: "Contest related information", imageIdentifier: "trophy", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Encounters", description: "How a Pokémon can be encountered in the wild", imageIdentifier: "swordEncounter", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Evolution", description: "Conditions and triggers for Pokémon evolution", imageIdentifier: "flowerEvolve", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Games", description: "Different Pokémon games that have been released", imageIdentifier: "videoGames", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Items", description: "Items that can be picked up, stored or used", imageIdentifier: "potion", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Locations", description: "Visitable locations in Pokémon games", imageIdentifier: "locationStarPin", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Machines", description: "Items that teach moves to Pokémon", imageIdentifier: "machine", segueIdentifier: "pokemonList"),
        MainMenuItem(name: "Moves", description: "Skills of Pokémon in battle", imageIdentifier: "move", segueIdentifier: "pokemonList")
    ]
}
