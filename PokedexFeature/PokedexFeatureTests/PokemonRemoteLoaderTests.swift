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
        let (_, client) = createSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let expectedURL = anyURL
        let (sut, client) = createSUT(with: expectedURL)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    // MARK: Helpers
    var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
    
    private func createSUT(with url: URL = URL(string: "https://a-url.com")!) -> (sut: PokemonRemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonRemoteLoader(url: url, client: client)
        
        return (sut: sut, client: client)
    }

}
