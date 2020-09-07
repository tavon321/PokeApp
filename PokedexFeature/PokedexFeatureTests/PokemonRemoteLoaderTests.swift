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
        
        expect(sut: sut, toCompleteWith: .failure(.connectivity)) {
            let expectedError = NSError(domain: "an error", code: 0)
            client.complete(with: expectedError)
        }
    }
    
    func test_load_deliversConnectivityErrorOnNon200HttpRespone() {
        let (sut, client) = createSUT()
        
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach { index, code in
            expect(sut: sut, toCompleteWith: .failure(.connectivity)) {
                let data = Data("[]".utf8)
                client.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }
    
    // MARK: Helpers
    var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    private func expect(sut: PokemonRemoteLoader,
                        toCompleteWith expectedResult: Result<[Pokemon], PokemonRemoteLoader.Error>,
                        file: StaticString = #file,
                        line: UInt = #line,
                        when action: () -> Void) {
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as PokemonRemoteLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
        }
    }
    
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
