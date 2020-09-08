//
//  PokemonDetail.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public struct PokemonDetail: Equatable {
    public var id: String
    public var name: String
    public var types: [Type]
    public var image: URL
    
    public init(id: String, name: String, types: [Type]) {
        self.id = id
        self.name = name
        self.types = types
        self.image = URL(string: "https://pokeres.bastionbot.org/images/pokemon/\(id).png")!
    }
}
