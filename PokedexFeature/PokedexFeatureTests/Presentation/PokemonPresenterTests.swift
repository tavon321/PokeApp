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
    
    private var pokemonLoadError: String { return "Couldn't load Pokemons" }
    
    init(errorView: PokemonErrorView, loadingView: PokemonLoadingView, pokemonView: PokemonView) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.pokemonView = pokemonView
    }
    
    func didStartLoadingPokemons() {
        errorView.display(.noError)
        loadingView.display(true)
    }
    
    func didFinishLoading(with pokemons: [Pokemon]) {
        loadingView.display(false)
        pokemonView.display(PokemonListViewModel(list: pokemons))
    }
    
    func didFinishLoading(with error: Error) {
        loadingView.display(false)
        errorView.display(PokemonErrorViewModel(message: pokemonLoadError))
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
    
    func test_didFinishLoadingPokemons_displayPokemonsAndStopLoading() {
        let (sut, view) = makeSUT()
        let pokemons = [anyPokemon]

        sut.didFinishLoading(with: pokemons)

        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(pokemons: pokemons)
        ])
    }
    
    func test_didFinishLoadingWithError_stopsLoadingAndDisplayErrorMessage() {
        let (sut, view) = makeSUT()
        let anyError = NSError(domain: "", code: 0)
        let errorMessage = "Couldn't load Pokemons"
        
        sut.didFinishLoading(with: anyError)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(errorMessage: errorMessage)
        ])
    }
    
    // MARK: - Helpers
    private var anyPokemon: Pokemon { return Pokemon(name: "name", url: anyURL)}
    private var anyURL: URL { return URL(string: "https://a-url.com")! }
    
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


