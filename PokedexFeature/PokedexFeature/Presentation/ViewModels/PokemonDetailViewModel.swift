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
    public let isLoading: Bool
    
    init(name: String, number: String?, types: (Image?, Image?)?, image: Image?, isLoading: Bool) {
        self.name = name.uppercasingFirst
        self.types = types
        self.image = image
        self.isLoading = isLoading
        
        if let number = number, let numberInt = Int(number) {
            self.number = String(format: "#%02d", numberInt)
        } else {
            self.number = nil
        }
    }
}
