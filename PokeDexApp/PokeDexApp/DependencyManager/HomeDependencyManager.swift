//
//  HomeDependencyManager.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

final class HomeDependencyManager {
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient()
    }()
    
    lazy var pokemonLoaderUseCase: PokemonRemoteLoader = {
        let pokemonURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=893")!
        return PokemonRemoteLoader(url: pokemonURL, client: httpClient)
    }()
    
    lazy var pokemonDetailLoaderUseCase: PokemonDetailLoader = {
        return PokemonDetailRemoteLoader(client: httpClient)
    }()
    
    lazy var pokemonImageLoaderUseCase: RemotePokemonImageLoader = {
        return RemotePokemonImageLoader(client: httpClient)
    }()
}
