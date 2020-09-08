//
//  PokemonDetailRemoteLoaderTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class PokemonDetailRemoteLoader: PokemonDetailLoader {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadDetail(with url: URL, completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        
    }
}

class PokemonDetailRemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let (_, client) = createSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    

    // MARK: Helpers
    private var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    private func createSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonDetailRemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonDetailRemoteLoader(client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut: sut, client: client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url: url, completion: completion))
        }
        
        func complete(with error: Error, at index: Int = 0, file: StaticString = #file, line: UInt = #line) {
            guard messages.count > index else {
                return XCTFail("getFromURL wasn't called", file: file, line: line)
            }
            
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int,
                      data: Data,
                      at index: Int = 0,
                      file: StaticString = #file,
                      line: UInt = #line) {
            guard messages.count > index else {
                return XCTFail("getFromURL wasn't called", file: file, line: line)
            }
            
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            
            messages[index].completion(.success((response, data)))
        }
    }
    
}
