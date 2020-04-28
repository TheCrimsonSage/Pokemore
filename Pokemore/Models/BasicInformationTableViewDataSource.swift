//
//  BasicInformationTableViewDataSource.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/26.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class BasicInformationTableViewDataSource<T> : NSObject, UITableViewDataSource where T: BasicInformationTableViewCell & UITableViewCell {

    var information: [(property: String, value: String)] = [
    ]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonViewConstants.pokemonCellReuseIdentifier) as! T
        let data = information[indexPath.row]
        cell.propertyLabel.text = data.property
        cell.valueLabel.text = data.value
        
        return cell
    }
}
