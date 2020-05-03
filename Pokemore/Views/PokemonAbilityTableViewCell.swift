//
//  PokemonAbilityTableViewCell.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/26.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class PokemonAbilityTableViewCell: UITableViewCell, BasicInformationTableViewCell {

    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var propertyFrame: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        propertyFrame.layer.cornerRadius = propertyFrame.frame.width/2
        // Configure the view for the selected state
    }
    
    func configure(property: String?, value: String?)
    {
        propertyLabel.text = property
        valueLabel.text = value
    }
}
