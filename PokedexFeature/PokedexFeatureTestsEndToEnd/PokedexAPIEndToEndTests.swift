//
//  PokedexAPIEndToEndTests.swift
//  PokedexFeatureTestsEndToEnd
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class PokedexAPIEndToEndTests: XCTestCase {

    func test_endToEndTestGetBurgerResult_matchesFixedTestAccountData() {
        switch getBurgerResult() {
        case .success(let pokemons):
            pokemons.enumerated().forEach { (index, receivedBurger) in
                XCTAssertEqual(receivedBurger, expectedItem(at: index))
            }
        default:
            XCTFail("Expected Success")
        }
    }
    
    // MARK: - Helpers
    private func getBurgerResult() -> PokemonLoader.Result? {
        let testServerURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=3")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = PokemonRemoteLoader(url: testServerURL, client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(loader)
        
        let exp = expectation(description: "wait for load completion")
        
        var captureResult: PokemonLoader.Result?
        loader.load { result in
            captureResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
        
        return captureResult
    }
    
    private func expectedItem(at index: Int) -> Pokemon {
        return Pokemon(name: name(at: index), url: url(at: index))
    }
    
    private func name(at index: Int) -> String {
        return ["bulbasaur", "ivysaur", "venusaur"][index]
    }
    
    private func url(at index: Int) -> URL {
        return [URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!,
                URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!,
                URL(string: "https://pokeapi.co/api/v2/pokemon/3/")!][index]
    }

}
