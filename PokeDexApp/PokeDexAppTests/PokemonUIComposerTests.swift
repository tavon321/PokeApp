//
//  PokemonUIComposerTests.swift
//  PokeDexAppTests
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFature
@testable import PokeDexApp

class PokemonUIComposerTests: XCTestCase {

    func test_pokemonsViewController_doesNotLeak() {
        let dependencyHandler = HomeDependencyManager()
        let sut = PokemonUIComposer.pokemonsViewController(with: dependencyHandler)
        
        trackForMemoryLeaks(dependencyHandler)
        trackForMemoryLeaks(sut)
    }
    
    func test_pokemonTableViewCellController_doesNotLeak() {
        let dependencyHandler = HomeDependencyManager()
        let sut = PokemonUIComposer.pokemonTableViewCellController(with: dependencyHandler, okemon(name: "a name", url: anyURL))
        
        trackForMemoryLeaks(dependencyHandler)
        trackForMemoryLeaks(sut)
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

}
