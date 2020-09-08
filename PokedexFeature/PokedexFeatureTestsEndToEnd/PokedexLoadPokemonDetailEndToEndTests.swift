//
//  PokedexLoadPokemonDetailEndToEndTests.swift
//  PokedexFeatureTestsEndToEnd
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class PokedexLoadPokemonDetailEndToEndTests: XCTestCase {
    
    func test_endToEndTestGetPokemonDetailResult_matchesFixedTestAccountData() {
        switch getPokemonDetailResult() {
        case .success(let pokemonDetail):
            XCTAssertEqual(pokemonDetail, expectedItem())
        default:
            XCTFail("Expected Success")
        }
    }
    
    private func getPokemonDetailResult() -> PokemonDetailLoader.Result? {
        let testServerURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = PokemonDetailRemoteLoader(client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(loader)
    
        let exp = expectation(description: "wait for load completion")
        
        var captureResult: PokemonDetailLoader.Result?
        loader.loadDetail(with: testServerURL) { result in
            captureResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
        
        return captureResult
    }
    
    // MARK: - Helpers
    private func expectedItem() -> PokemonDetail {
        return PokemonDetail(id: "1", name: "bulbasaur", types: [Type(name: "grass"), Type(name: "poison")])
    }
    
}
