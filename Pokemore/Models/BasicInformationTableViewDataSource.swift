//
//  BasicInformationTableViewDataSource.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/26.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class BasicInformationTableViewDataSource : NSObject, UITableViewDataSource{

    var information: [BasicInformationCellDataSource] = [BasicInformationCellDataSource]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information[section].Count()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return information.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return information[indexPath.section].PopulateCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        information[section].GetName()
    }
    
    public init(information: [BasicInformationCellDataSource]) {
        self.information = information
    }
    
}

extension BasicInformationTableViewDataSource : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground

        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 28, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = information[section].GetName()
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
