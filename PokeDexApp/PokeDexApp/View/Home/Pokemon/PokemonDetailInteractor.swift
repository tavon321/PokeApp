//
//  PokemonDetailInteractor.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation
import PokedexFeature

final class PokemonDetailInteractor<View: PokemonDetailView, Image>: PokemonTableViewCellControllerDelegate where View.Image == Image {
    
    private let detailLoader: PokemonDetailLoader
    private let pokemonImageLoader: PokemonImageLoader
    
    var presenter: PokemonDetailPresenter<View, Image>?
    
    init(detailLoader: PokemonDetailLoader, pokemonImageLoader: PokemonImageLoader) {
        self.detailLoader = detailLoader
        self.pokemonImageLoader = pokemonImageLoader
    }
    
    func didRequestDetail(for pokemon: Pokemon) {
        presenter?.didStartLoadingDetailData(for: pokemon)
        
        detailLoader.loadDetail(with: pokemon.url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detail):
                self.presenter?.didFinishLoadingDetailData(for: detail)
            case .failure(let error):
                self.presenter?.didFinishLoadingDetailData(with: error, for: pokemon)
            }
        }
    }
}
