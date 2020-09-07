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
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class PokemonRemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let client = HTTPClientSpy()
        _ = PokemonRemoteLoader(url: anyURL, client: client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let expectedURL = anyURL
        let sut = PokemonRemoteLoader(url: expectedURL, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [expectedURL])
    }
    
    // MARK: Helpers
    var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }

}
