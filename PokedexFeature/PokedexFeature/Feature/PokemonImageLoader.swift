//
//  PokemonImageLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/9/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol PokemonImageLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(with url: URL, completion: (Result) -> Void)
}
