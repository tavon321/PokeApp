//
//  PokemonRemoteLoaderTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class PokemonRemoteLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class PokemonRemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let client = HTTPClientSpy()
        _ = PokemonRemoteLoader(url: anyURL, client: client)
        
        XCTAssertEqual(client.getFromURLCallCount, 0)
    }
    
    // MARK: Helpers
    var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    class HTTPClientSpy: HTTPClient {
        var getFromURLCallCount = 0
        
        func get(from url: URL) {
            getFromURLCallCount += 1
        }
    }

}
