//
//  PokemonTableViewCell.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

final class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet private var pokemonName: UILabel!
    @IBOutlet private var pokemonNumber: UILabel!
    @IBOutlet private var pokemonImageView: UIImageView!
    
    @IBOutlet private var pokemonFirstElement: UIImageView!
    @IBOutlet private var pokemonSecondElement: UIImageView!
    
    func set(title: String) {
        pokemonName.text = title
    }
    
    func set(elementImages: (UIImage?, UIImage?)?) {
        set(elementImages?.0, for: pokemonFirstElement)
        set(elementImages?.1, for: pokemonSecondElement)
    }
    
    private func set(_ image: UIImage?, for imageView: UIImageView) {
        if let image = image {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.isHidden = false
        }
    }
    
    func set(number: String?) {
        guard let number = number else {
            return pokemonNumber.isHidden = true
        }
        pokemonNumber.text = number
        pokemonNumber.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pokemonFirstElement.image = nil
        pokemonSecondElement.image = nil
    }
}
