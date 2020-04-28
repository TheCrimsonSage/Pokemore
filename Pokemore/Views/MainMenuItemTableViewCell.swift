//
//  MainMenuItemTableViewCell.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/16.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import UIKit

class MainMenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
