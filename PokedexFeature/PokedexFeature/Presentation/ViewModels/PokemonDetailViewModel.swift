//
//  PokemonDetailViewModel.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public struct PokemonDetailViewModel<Image> {
    public let name: String
    public let number: String?
    public let types: (Image?, Image?)?
    public let image: Image?
    
    init(name: String, number: String?, types: (Image?, Image?)?, image: Image?) {
        self.name = name.uppercasingFirst
        self.types = types
        self.image = image
        
        if let number = number, let numberInt = Int(number) {
            self.number = String(format: "#%02d", numberInt)
        } else {
            self.number = nil
        }
    }
}
