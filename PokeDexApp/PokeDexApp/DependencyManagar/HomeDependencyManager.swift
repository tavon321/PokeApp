//
//  HomeDependencyManager.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

class HomeDependencyManager {
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient()
    }()
    
    private lazy var PokemonLoaderUseCase: PokemonRemoteLoader = {
        let pokemonURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1050")!
        return PokemonRemoteLoader(url: pokemonURL, client: httpClient)
    }()

}


public final class PokemonUIComposer {
    private init() {}
    
    
    
}
