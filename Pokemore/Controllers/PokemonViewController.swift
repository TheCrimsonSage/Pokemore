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
    @IBOutlet weak var abilitiesTableView: UITableView!
    @IBOutlet weak var movesTableView: UITableView!
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var abilitiesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statsTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var movesTableViewHeightConstraint: NSLayoutConstraint!
    @Injected var pokemonState: PokeApiPokemonState
    var pokemonId: String? // Optional to prevent race condition where delegate callback is called before Id is assigned
    var pokemon: Pokemon?
    let basicDataSource = BasicInformationTableViewDataSource<PokemonBasicInformationTableViewCell>()
    let abilitiesDataSource = BasicInformationTableViewDataSource<PokemonAbilityTableViewCell>()
    let movesDataSource = BasicInformationTableViewDataSource<PokemonAbilityTableViewCell>()
    let statsDataSource = BasicInformationTableViewDataSource<PokemonBasicInformationTableViewCell>()

    override func viewDidLoad() {
        super.viewDidLoad()
        basicInfoTableView.register(UINib(nibName: PokemonViewConstants.pokemonBasicInformationTableViewXib, bundle: nil), forCellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier)
        abilitiesTableView.register(UINib(nibName: PokemonViewConstants.pokemonAbilityTableViewXib, bundle: nil), forCellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier)
        movesTableView.register(UINib(nibName: PokemonViewConstants.pokemonAbilityTableViewXib, bundle: nil), forCellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier)
        statsTableView.register(UINib(nibName: PokemonViewConstants.pokemonBasicInformationTableViewXib, bundle: nil), forCellReuseIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier)
        pokemonState.delegate = self
        
        basicInfoTableView.dataSource = basicDataSource
        abilitiesTableView.dataSource = abilitiesDataSource
        movesTableView.dataSource = movesDataSource
        statsTableView.dataSource = statsDataSource
        statsTableView.tableFooterView = UIView() // Remove unnecessary cells by setting empty footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokemonState.delegate = self
        populateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pokemonState.delegate = nil
    }
    
    func recalculateViewHeights() {
        abilitiesTableViewHeightConstraint.constant = CGFloat(42 + (abilitiesDataSource.information.count * 42))
        movesTableViewHeightConstraint.constant = CGFloat(42 + (movesDataSource.information.count * 42))
        statsTableViewHeightConstraint.constant = CGFloat(42 + (statsDataSource.information.count * 42))
    }
    
    func populateView() {
        if let pokemonIdValue = pokemonId {
           pokemon = pokemonState.getPokemonById(at: pokemonIdValue);
            title = (pokemon?.name)?.capitalized
            if let unwrappedData = pokemonState.getPokemonSpriteById(at: pokemonIdValue) {
                pokemonImageView.image = UIImage(data: unwrappedData)
            }
            if let unwrappedPokemon = pokemon {
                basicDataSource.information =
                [
                    (property: "Base experience", value: String(unwrappedPokemon.baseExperience)),
                    (property: "Height", value: String(unwrappedPokemon.height)),
                    (property: "Order", value: String(unwrappedPokemon.order)),
                    (property: "Weight", value: String(unwrappedPokemon.weight)),
                    (property: "Species", value: String(unwrappedPokemon.species.name.capitalized)),
                ]
                abilitiesDataSource.information = unwrappedPokemon.abilities.map({ (ability) -> (property: String, value: String) in
                    (property: String(ability.slot), value: String(ability.ability.name.replacingOccurrences(of: "-", with: " ").capitalized))
                })
                movesDataSource.information = unwrappedPokemon.moves.map({ (move) -> (property: String, value: String) in
                    (property: String(move.versionGroupDetails.first?.levelLearnedAt ?? 0), value: move.move.name.replacingOccurrences(of: "-", with: " ").capitalized)
                }).sorted(by: { Int($0.property) ?? 0 < Int($1.property) ?? 0})
                statsDataSource.information = unwrappedPokemon.stats.map({ (stat) -> (property: String, value: String) in
                    (property: stat.stat.name.replacingOccurrences(of: "-", with: " ").capitalized, value: String(stat.baseStat))
                }).sorted(by: { $0.property < $1.property})
            }
            else{
                basicDataSource.information =
                [
                    (property: "Base experience", ""),
                    (property: "Height", value: ""),
                    (property: "Order", value: ""),
                    (property: "Weight", value: ""),
                    (property: "Species", value: ""),
                ]
            }
            recalculateViewHeights()
            DispatchQueue.main.async {
                self.basicInfoTableView.reloadData()
                self.abilitiesTableView.reloadData()
                self.movesTableView.reloadData()
                self.statsTableView.reloadData()
            }
        }
    }
}

// MARK: PokemonViewConstants

class PokemonViewConstants {
    static let pokemonBasicInformationTableViewXib = "PokemonBasicInformationTableViewCell"
    static let pokemonAbilityTableViewXib = "PokemonAbilityTableViewCell"
    static let pokemonCellReuseIdentifier = "PokemonBasicItem"
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

