//
//  PokemonTableViewCell.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet private var pokemonName: UILabel!
    @IBOutlet private var pokemonNumber: UILabel!
    @IBOutlet private var pokemonImageView: UIImageView!
    
    @IBOutlet private var pokemonFirstElement: UIImageView!
    @IBOutlet private var pokemonSecondElement: UIImageView!
    
    func set(title: String) {
        pokemonName.text = title
    }
    
    func set(number: String?) {
        guard let number = number else {
            return pokemonNumber.isHidden = true
        }
        pokemonNumber.text = number
        pokemonNumber.isHidden = false
    }
}
