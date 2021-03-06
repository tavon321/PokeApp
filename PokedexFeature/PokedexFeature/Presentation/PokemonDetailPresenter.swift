//
//  PokemonDetailPresenter.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol PokemonDetailView {
    associatedtype Image
    
    func display(_ model: PokemonDetailViewModel<Image>)
}

public final class PokemonDetailPresenter<View: PokemonDetailView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    private let typeImageTransformer: (String?) -> Image?
    
    public init(view: View, typeImageTransformer: @escaping (String?) -> Image?, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
        self.typeImageTransformer = typeImageTransformer
    }
    
    public func didStartLoadingDetailData(for model: Pokemon) {
        view.display(PokemonDetailViewModel(name: model.name, number: nil, types: nil, image: nil, isLoading: true))
    }
    
    public func didFinishLoadingDetailData(for model: PokemonDetail) {
        view.display(PokemonDetailViewModel(name: model.name,
                                            number: model.id,
                                            types: getTypeImages(for: model.types),
                                            image: nil,
                                            isLoading: true))
    }
    
    public func didFinishLoadingDetailData(with error: Error, for model: Pokemon) {
        view.display(PokemonDetailViewModel(name: model.name, number: nil, types: nil, image: nil, isLoading: false))
    }
    
    public func didStatLoadingImageData(for model: PokemonDetail) {
        // TODO: Add a loader on the pokemon image if have time
        view.display(PokemonDetailViewModel(name: model.name,
                                            number: model.id,
                                            types: getTypeImages(for: model.types),
                                            image: nil,
                                            isLoading: true))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: PokemonDetail) {
        view.display(PokemonDetailViewModel(name: model.name,
                                            number: model.id,
                                            types: getTypeImages(for: model.types),
                                            image: nil,
                                            isLoading: false))
    }
    
    public func didFinishLoadingImageData(for model: PokemonDetail, data: Data) {
        let image = imageTransformer(data)
        
        view.display(PokemonDetailViewModel(name: model.name,
                                            number: model.id,
                                            types: getTypeImages(for: model.types),
                                            image: image, isLoading: false))
    }
    
    // MARK: - Helpers
    private func getTypeImages(for types: [Type]) -> (Image?, Image?) {
        guard types.count <= 2  else {
            fatalError("Everyone knows that pokemons can only have 2 types.")
        }
        
        return (typeImageTransformer(types[safe: 0]?.name), typeImageTransformer(types[safe: 1]?.name))
    }
}
