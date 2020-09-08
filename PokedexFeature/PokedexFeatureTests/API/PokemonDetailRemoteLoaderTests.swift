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
    
    enum Error: Swift.Error {
        case connectivity
    }

    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadDetail(with url: URL, completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.failure(Error.connectivity))
            default: break
            }
        }
    }
}

class PokemonDetailRemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let (_, client) = createSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadDetailTwice_requestDataFromURLTwice() {
        let expectedURL = anyURL
        let (sut, client) = createSUT()
        
        sut.loadDetail(with: expectedURL) { _ in }
        sut.loadDetail(with: expectedURL) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    func test_loadDetail_deliversConnectivityErrorOnClientError() {
        let (sut, client) = createSUT()
        
        expect(sut: sut, toCompleteWith: .failure(.connectivity)) {
            let expectedError = NSError(domain: "an error", code: 0)
            client.complete(with: expectedError)
        }
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
    
    private func expect(sut: PokemonDetailRemoteLoader,
                        toCompleteWith expectedResult: Result<PokemonDetail, PokemonDetailRemoteLoader.Error>,
                        file: StaticString = #file,
                        line: UInt = #line,
                        when action: () -> Void) {
        let exp = expectation(description: "Wait for result")
        
        sut.loadDetail(with: anyURL) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem)
            case let (.failure(receivedError as PokemonDetailRemoteLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 0.1)
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
