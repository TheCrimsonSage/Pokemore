//
//  PokemonViewController.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/21.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var basicInfoTableView: UITableView!
    
    @Injected var pokemonState: PokeApiPokemonState
    var pokemonId: String? // Optional to prevent race condition where delegate callback is called before Id is assigned
    var pokemon: Pokemon?
    let tableViewDataSource = BasicInformationTableViewDataSource(
        information: [
            BasicInformationCellDataSourceProvider<PokemonBasicInformationTableViewCell>(name: "Basic Information", cellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier),
            BasicInformationCellDataSourceProvider<PokemonAbilityTableViewCell>(name: "Abilities", cellReuseIdentifier: PokemonViewConstants.pokemonCircleCellReuseIdentifier),
            BasicInformationCellDataSourceProvider<PokemonAbilityTableViewCell>(name: "Moves", cellReuseIdentifier: PokemonViewConstants.pokemonCircleCellReuseIdentifier),
            BasicInformationCellDataSourceProvider<PokemonBasicInformationTableViewCell>(name: "Stats", cellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier)
        ]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicInfoTableView.register(UINib(nibName: PokemonViewConstants.pokemonBasicInformationTableViewXib, bundle: nil), forCellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier)
        basicInfoTableView.register(UINib(nibName: PokemonViewConstants.pokemonAbilityTableViewXib, bundle: nil), forCellReuseIdentifier: PokemonViewConstants.pokemonCircleCellReuseIdentifier)
        pokemonState.delegate = self
        
        basicInfoTableView.dataSource = tableViewDataSource
        basicInfoTableView.delegate = tableViewDataSource
        basicInfoTableView.tableFooterView = UIView() // Remove unnecessary cells by setting empty footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokemonState.delegate = self
        populateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pokemonState.delegate = nil
    }
    
    func recalculateViewHeights() {
        //basi.constant = CGFloat(42 + (abilitiesDataSource.information.count * 42))
    }
    
    func populateView() {
        if let pokemonIdValue = pokemonId {
            pokemon = pokemonState.getPokemonById(at: pokemonIdValue);
            title = (pokemon?.name)?.capitalized
            if let unwrappedData = pokemonState.getPokemonSpriteById(at: pokemonIdValue) {
                if pokemonImageView != nil {
                    pokemonImageView.image = UIImage(data: unwrappedData)
                }
            }
            if let unwrappedPokemon = pokemon {
                tableViewDataSource.information[0].UpdateValues(with:
                    [
                        (property: "Base experience", value: String(unwrappedPokemon.baseExperience)),
                        (property: "Height", value: String(unwrappedPokemon.height)),
                        (property: "Order", value: String(unwrappedPokemon.order)),
                        (property: "Weight", value: String(unwrappedPokemon.weight)),
                        (property: "Species", value: String(unwrappedPokemon.species.name.capitalized)),
                ])
                tableViewDataSource.information[1].UpdateValues(with: unwrappedPokemon.abilities.map({ (ability) -> (property: String, value: String) in
                    (property: String(ability.slot), value: String(ability.ability.name.replacingOccurrences(of: "-", with: " ").capitalized))
                }))
                tableViewDataSource.information[2].UpdateValues(with: unwrappedPokemon.moves.map({ (move) -> (property: String, value: String) in
                    (property: String(move.versionGroupDetails.first?.levelLearnedAt ?? 0), value: move.move.name.replacingOccurrences(of: "-", with: " ").capitalized)
                }).sorted(by: { Int($0.property) ?? 0 < Int($1.property) ?? 0}))
                tableViewDataSource.information[3].UpdateValues(with: unwrappedPokemon.stats.map({ (stat) -> (property: String, value: String) in
                    (property: stat.stat.name.replacingOccurrences(of: "-", with: " ").capitalized, value: String(stat.baseStat))
                }).sorted(by: { $0.property < $1.property}))
            }
            else{
                tableViewDataSource.information[0].UpdateValues(with:
                    [
                        (property: "Base experience", ""),
                        (property: "Height", value: ""),
                        (property: "Order", value: ""),
                        (property: "Weight", value: ""),
                        (property: "Species", value: ""),
                ])
            }
            recalculateViewHeights()
            DispatchQueue.main.async {
                self.basicInfoTableView.reloadData()
            }
        }
    }
}

// MARK: PokemonViewConstants

class PokemonViewConstants {
    static let pokemonBasicInformationTableViewXib = "PokemonBasicInformationTableViewCell"
    static let pokemonAbilityTableViewXib = "PokemonAbilityTableViewCell"
    static let pokemonCellReuseIdentifier = "PokemonBasicItem"
    static let pokemonCircleCellReuseIdentifier = "PokemonBasicCircleItem"
}

// MARK: PokeApiPokemonStateDelegate

extension PokemonViewController: PokeApiPokemonStateDelegate {
    func onPokemonUpdated(pokemon: Pokemon) {
        DispatchQueue.main.async {
            self.populateView()
        }
    }
    
    func onPokemonSpriteUpdated(sprite: Data) {
        DispatchQueue.main.async {
            self.populateView()
        }
    }
}

