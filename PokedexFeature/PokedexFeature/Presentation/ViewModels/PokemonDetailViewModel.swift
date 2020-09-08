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
    public let types: (Image, Image?)?
    public let image: Image?
}
