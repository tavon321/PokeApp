//
//  PokemonViewModels.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public struct PokemonErrorViewModel {
    public let message: String?
    
    public static var noError: PokemonErrorViewModel {
        return PokemonErrorViewModel(message: nil)
    }
}

public struct PokemonListViewModel {
    public var list: [Pokemon]
}
