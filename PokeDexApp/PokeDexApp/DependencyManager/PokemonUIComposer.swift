//
//  PokemonUIComposer.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

final class PokemonUIComposer {
    private init() {}
    
    static func pokemonsViewController(with dependecyHandler: HomeDependencyManager) -> PokemonsViewController {
        let controller = PokemonsViewController.instantiate(with: .homeStoryboard)!
        let presenter = PokemonPresenter(errorView: WeakRefVirtualProxy(controller),
                                         loadingView: WeakRefVirtualProxy(controller),
                                         pokemonView: WeakRefVirtualProxy(controller))
        let interactor = PokemonInteractor(pokemonUseCase: dependecyHandler.pokemonLoaderUseCase)
        
        interactor.presenter = presenter
        controller.delegate = interactor
        controller.dependecyHandler = dependecyHandler
        return controller
    }
    
    static func pokemonTableViewCellController(with dependecyHandler: HomeDependencyManager, pokemon: Pokemon) -> PokemonTableViewCellController {
        let interactor = PokemonDetailInteractor<WeakRefVirtualProxy<PokemonTableViewCellController>, UIImage>(detailLoader: dependecyHandler.pokemonDetailLoaderUseCase)
        let controller = PokemonTableViewCellController(pokemon: pokemon, delegate: interactor)
        let presenter = PokemonDetailPresenter(view: WeakRefVirtualProxy(controller),
                                               typeImageTransformer: { type in
                                                guard let type = type else { return nil }
                                                return UIImage(named: type)
        },
                                               imageTransformer: { _ in nil })
        
        interactor.presenter = presenter
        
        return controller
    }
    
}