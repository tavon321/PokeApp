//
//  RemotePokemonImageLoaderTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/9/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class RemotePokemonImageLoader: PokemonImageLoader {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(url: URL, completion: (PokemonImageLoader.Result) -> Void) {
    }
}

class RemotePokemonImageLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let (_, client) = createSUT(url: anyURL)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: Helpers
    private func createSUT(url: URL, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonImageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonImageLoader(client: client)
        
        return (sut: sut, client: client)
    }

}
