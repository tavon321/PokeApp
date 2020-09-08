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
        
        return controller
    }
    
}
