//
//  PokemonDetailViewModel.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public struct PokemonDetailViewModel<Image> {
    let name: String
    let order: String
    let types: (Image?, Image?)
    let image: Image?
}
