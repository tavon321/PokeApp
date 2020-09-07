//
//  PokemonPresenterTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

struct PokemonErrorViewModel {
    public let message: String?
    
    static var noError: PokemonErrorViewModel {
        return PokemonErrorViewModel(message: nil)
    }
}

struct PokemonListViewModel {
    var list: [Pokemon]
}

protocol PokemonView {
    func display(_ viewModel: PokemonListViewModel)
}

protocol PokemonErrorView {
    func display(_ viewModel: PokemonErrorViewModel)
}

public protocol PokemonLoadingView {
    func display(_ isLoading: Bool)
}

class PokemonPresenter {
    private let errorView: PokemonErrorView
    private let loadingView: PokemonLoadingView
    private let pokemonView: PokemonView
    
    init(errorView: PokemonErrorView, loadingView: PokemonLoadingView, pokemonView: PokemonView) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.pokemonView = pokemonView
    }
    
    func didStartLoadingPokemons() {
        errorView.display(.noError)
        loadingView.display(true)
    }
    
}

class PokemonPresenterTests: XCTestCase {
    
    func test_didStartLoadingPokemons_displayNoErrorAndStartLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingPokemons()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = PokemonPresenter(errorView: view, loadingView: view, pokemonView: view)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: PokemonView, PokemonLoadingView, PokemonErrorView {
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(pokemons: [Pokemon])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ isLoading: Bool) {
            messages.insert(.display(isLoading: isLoading))
        }
        
        func display(_ viewModel: PokemonListViewModel) {
            messages.insert(.display(pokemons: viewModel.list))
        }
        
        func display(_ viewModel: PokemonErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
    }
}


