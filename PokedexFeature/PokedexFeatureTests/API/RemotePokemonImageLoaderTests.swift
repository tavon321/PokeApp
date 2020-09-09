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
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(with url: URL, completion: @escaping (PokemonImageLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success: break
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

class RemotePokemonImageLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let (_, client) = createSUT(url: anyURL)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() {
        let expectedURL = anyURL
        let (sut, client) = createSUT(url: expectedURL)
        
        sut.loadImageData(with: expectedURL) { _ in }
        sut.loadImageData(with: expectedURL) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    func test_loadImageDataFromURL_deliversConnectivityErrorOnClientError() {
        let (sut, client) = createSUT(url: anyURL)
        let clientError = NSError(domain: "a client error", code: 0)

        expect(sut: sut, toCompleteWith: .failure(.connectivity), when: {
            client.complete(with: clientError)
        })
    }
    
    // MARK: Helpers
    private func expect(sut: RemotePokemonImageLoader,
                        toCompleteWith expectedResult: Result<Data, RemotePokemonImageLoader.Error>,
                        file: StaticString = #file,
                        line: UInt = #line,
                        when action: () -> Void) {
        let exp = expectation(description: "Wait for result")
        
        sut.loadImageData(with: anyURL) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem)
            case let (.failure(receivedError as RemotePokemonImageLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 0.1)
    }
    
    private func createSUT(url: URL, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonImageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonImageLoader(client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        
        return (sut: sut, client: client)
    }

}
