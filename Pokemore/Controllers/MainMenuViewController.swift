//
//  ViewController.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/16.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @Injected var pokemonState: PokeApiPokemonState
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonState.updateListState(tillIndex: 100)
        menuTableView.register(UINib(nibName: Constants.TableViewCell.MainMenuCellXib, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.MainMenuCellIdentifier)
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.tableFooterView = UIView() // Remove unnecessary cells by setting empty footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

// MARK: UITableViewDataSource

extension MainMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.mainMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainMenuItem = Constants.mainMenuItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.MainMenuCellIdentifier, for: indexPath) as! MainMenuItemTableViewCell
        
        cell.itemNameLabel.text = mainMenuItem.name
        cell.itemDescriptionLabel.text = mainMenuItem.description
        cell.itemImageView?.image = UIImage(named: mainMenuItem.imageIdentifier)
        cell.selectionStyle = .none // We don't want the selection to be highlighted
      
        return cell
    }
}

// MARK: UITableViewDelegate

extension MainMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainMenuItem = Constants.mainMenuItems[indexPath.row]
        performSegue(withIdentifier: mainMenuItem.segueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editViewController = segue.destination as? PokemonListViewController {
            editViewController.pokemonState = pokemonState
        }
    }
}

