//
//  PokemonDetailLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol PokemonDetailLoader {
    typealias Result = Swift.Result<PokemonDetail, Error>
    
    func loadDetail(with url: URL, completion: @escaping (Result) -> Void)
}
