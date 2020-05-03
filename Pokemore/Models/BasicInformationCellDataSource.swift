//
//  BasicInformationCellDataSource.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/05/03.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

protocol BasicInformationCellDataSource {
    func PopulateCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func UpdateValues(with values: [(property: String, value: String)])
    func GetName () -> String?
    func Count() -> Int
}

class BasicInformationCellDataSourceProvider<T>: BasicInformationCellDataSource where T: BasicInformationTableViewCell & UITableViewCell {
    private var values: [(property: String, value: String)] = [(property: String, value: String)]()
    private let name: String?
    private let cellReuseIdentifier: String

    func PopulateCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! T
        let data = values[indexPath.row]
        cell.configure(property: data.property, value: data.value)
        return cell
    }
    
    func Count() -> Int {
        return values.count
    }
    
    func GetName() -> String? {
        return name
    }
    
    func UpdateValues(with values: [(property: String, value: String)]) {
        self.values = values
    }

    public init(name: String?, cellReuseIdentifier: String) {
        self.name = name
        self.cellReuseIdentifier = cellReuseIdentifier
    }
}
