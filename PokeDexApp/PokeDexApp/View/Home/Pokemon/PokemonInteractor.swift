//
//  PokemonInteractor.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation
import PokedexFeature

public protocol PokemonViewControllerDelegate {
    func didRequestPokemonData()
}

final class PokemonInteractor: PokemonViewControllerDelegate {
    
    private var pokemonUseCase: PokemonRemoteLoader
    
    var presenter: PokemonPresenter?
    
    init(pokemonUseCase: PokemonRemoteLoader) {
        self.pokemonUseCase = pokemonUseCase
    }
    
    func didRequestPokemonData() {
        presenter?.didStartLoadingPokemons()
        
        pokemonUseCase.load { [weak self]  result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemons):
                self.presenter?.didFinishLoading(with: pokemons)
            case .failure(let error):
                self.presenter?.didFinishLoading(with: error)
            }
        }
        
    }
    
}
