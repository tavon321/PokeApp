//
//  PokemonPresenter.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol PokemonView {
    func display(_ viewModel: PokemonListViewModel)
}

public protocol PokemonErrorView {
    func display(_ viewModel: PokemonErrorViewModel)
}

public protocol PokemonLoadingView {
    func display(_ isLoading: Bool)
}

public class PokemonPresenter {
    private let errorView: PokemonErrorView
    private let loadingView: PokemonLoadingView
    private let pokemonView: PokemonView
    
    private var pokemonLoadError: String { return "Couldn't load Pokemons" }
    
    public init(errorView: PokemonErrorView, loadingView: PokemonLoadingView, pokemonView: PokemonView) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.pokemonView = pokemonView
    }
    
    public func didStartLoadingPokemons() {
        errorView.display(.noError)
        loadingView.display(true)
    }
    
    public func didFinishLoading(with pokemons: [Pokemon]) {
        loadingView.display(false)
        pokemonView.display(PokemonListViewModel(list: pokemons))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.display(false)
        errorView.display(PokemonErrorViewModel(message: pokemonLoadError))
    }
    
}
