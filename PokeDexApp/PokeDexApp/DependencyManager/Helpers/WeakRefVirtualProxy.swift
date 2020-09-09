//
//  WeakRefVirtualProxy.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}


extension WeakRefVirtualProxy: PokedexFeature.PokemonErrorView where T: PokedexFeature.PokemonErrorView {
    func display(_ viewModel: PokemonErrorViewModel) {
        object?.display(viewModel)
    }
}


extension WeakRefVirtualProxy: PokemonLoadingView where T: PokemonLoadingView {
    func display(_ isLoading: Bool) {
        object?.display(isLoading)
    }
}

extension WeakRefVirtualProxy: PokemonView where T: PokemonView {
    func display(_ viewModel: PokemonListViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PokemonDetailView where T: PokemonDetailView, T.Image == UIImage {
    func display(_ model: PokemonDetailViewModel<UIImage>) {
        object?.display(model)
    }
}
