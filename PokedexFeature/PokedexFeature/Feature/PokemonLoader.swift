//
//  PokemonLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol PokemonLoader {
    typealias Result = Swift.Result<[Pokemon], Error>
    
    public func load(completion: (Result) -> Void)
}
