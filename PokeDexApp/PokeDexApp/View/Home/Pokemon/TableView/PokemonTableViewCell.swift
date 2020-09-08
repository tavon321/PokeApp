//
//  PokemonTableViewCell.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var pokemonName: UILabel!
    @IBOutlet private weak var pokemonNumber: UILabel!
    
    @IBOutlet private weak var pokemonFirstElement: UIImageView!
    @IBOutlet private weak var pokemonSecondElement: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(title: String) {
        pokemonName.text = title
    }

}
