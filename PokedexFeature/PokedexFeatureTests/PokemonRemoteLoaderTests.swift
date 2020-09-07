//
//  PokemonRemoteLoaderTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class PokemonRemoteLoader: PokemonLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    private static var OK_200: Int { return 200 }
    
    enum Error: Swift.Error {
        case connectivity
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (PokemonLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success((let httpRespone, _)):
                guard httpRespone.statusCode == PokemonRemoteLoader.OK_200 else {
                    return completion(.failure(Error.connectivity))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

protocol HTTPClient {
    typealias Result = Swift.Result<(response: HTTPURLResponse, data: Data), Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

class PokemonRemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let (_, client) = createSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let expectedURL = anyURL
        let (sut, client) = createSUT(with: expectedURL)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = createSUT()
        
        
        let exp = expectation(description: "wait for result")
        sut.load { result in
            switch result {
            case let .failure(receivedError as PokemonRemoteLoader.Error):
                XCTAssertEqual(receivedError, PokemonRemoteLoader.Error.connectivity)
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        let expectedError = NSError(domain: "an error", code: 0)
        client.complete(with: expectedError)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_load_deliversConnectivityErrorOnNon200HttpRespone() {
        let (sut, client) = createSUT()
        let expectedError: PokemonRemoteLoader.Error = .connectivity
        
        let exp = expectation(description: "wait for result")
        sut.load { result in
            switch result {
            case let .failure(receivedError as PokemonRemoteLoader.Error):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        let data = Data("[]".utf8)
        client.complete(withStatusCode: 199, data: data)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    // MARK: Helpers
    var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    class HTTPClientSpy: HTTPClient {
        var completions = [(HTTPClient.Result) -> Void]()
        var requestedURLs = [URL]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0, file: StaticString = #file, line: UInt = #line) {
            guard completions.count > index else {
                return XCTFail("getFromURL wasn't called", file: file, line: line)
            }
            
            completions[index](.failure(error))
        }
        
        func complete(withStatusCode code: Int,
                      data: Data,
                      at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            
            completions[index](.success((response, data)))
        }
    }
    
    private func createSUT(with url: URL = URL(string: "https://a-url.com")!) -> (sut: PokemonRemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonRemoteLoader(url: url, client: client)
        
        return (sut: sut, client: client)
    }

}
