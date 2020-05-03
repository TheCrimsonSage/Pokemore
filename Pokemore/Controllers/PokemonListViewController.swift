//
//  PokemonListViewController.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/16.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController {

    @Injected var pokemonState: PokeApiPokemonState
    var pokemonList: [NamedApiResponse] = [NamedApiResponse]()
    let pokemonViewSegueIdentifier: String = "pokemonView"

    @IBOutlet weak var pokemonListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonList = pokemonState.getCurrentListState()
        pokemonListTableView.register(UINib(nibName: Constants.TableViewCell.PokemonListCellXib, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.PokemonListCellIdentifier)
        pokemonListTableView.dataSource = self
        pokemonListTableView.delegate = self
        pokemonListTableView.tableFooterView = UIView() // Remove unnecessary cells by setting empty footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokemonState.listDelegate = self
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        pokemonListTableView?.reloadData()
    }
}


// MARK: UITableViewDataSource

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemonItem = pokemonList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.PokemonListCellIdentifier, for: indexPath) as! PokemonListTableViewCell
        
        cell.nameLabel.text = pokemonItem.name.capitalized
        if let spriteData = pokemonState.getPokemonSpriteById(at: pokemonItem.name){
            cell.pokemonImageView?.image = UIImage(data: spriteData)
        }
        
        cell.selectionStyle = .none // We don't want the selection to be highlighted
        return cell
    }
}

// MARK: UITableViewDelegate

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonItem = pokemonList[indexPath.row]
        pokemonState.prefetchPokemon(atUrl: pokemonItem.url, name: pokemonItem.name, index: indexPath.row) //Prefetch item to be displayed in next view
        performSegue(withIdentifier: pokemonViewSegueIdentifier, sender: pokemonItem.name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editViewController = segue.destination as? PokemonViewController {
            editViewController.pokemonId = sender as? String
        }
    }
}

// MARK: PokeApiPokemonStateDelegate

extension PokemonListViewController: PokeApiListStateDelegate {
    func onPokemonListUpdated(_ list: [NamedApiResponse]) {
        DispatchQueue.main.async {
            self.pokemonListTableView?.reloadData()
        }
    }
    
    func onRowUpdate(at position: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: position, section: 0)
            if(self.pokemonListTableView.numberOfRows(inSection: 0) > indexPath.row)
            {
                self.pokemonListTableView?.reloadRows(at: [indexPath], with: .fade)
            }
            
        }
    }
}
