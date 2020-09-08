//
//  PokemonDetail.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public struct PokemonDetail: Equatable {
    var id: String
    var name: String
    var types: [Type]
    var order: String
    var image: URL
}
