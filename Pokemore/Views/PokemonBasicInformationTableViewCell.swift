//
//  PokemonBasicInformationTableViewCell.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/22.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class PokemonBasicInformationTableViewCell: UITableViewCell, BasicInformationTableViewCell {
    

    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(property: String?, value: String?) {
        propertyLabel.text = property
        valueLabel.text = value
    }
}
