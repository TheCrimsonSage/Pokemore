//
//  PokemonListTableViewCell.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/18.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class PokemonListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
