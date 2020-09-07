//
//  PokemonRemoteLoaderTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature


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

    func test_load_deliversInvalidDataErrorOnNon200HttpRespone() {
        let (sut, client) = createSUT()

        let samples = [199, 201, 300, 400, 500].enumerated()

        samples.forEach { index, code in
            expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
                let data = Data("[]".utf8)
                client.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidData() {
        let (sut, client) = createSUT()

        expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
            let invalidData = Data("invalid data".utf8)
            client.complete(withStatusCode: 200, data: invalidData)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONItems() {
        let (sut, client) = createSUT()
        expect(sut: sut, toCompleteWith: .success([])) {
            let emptyData = self.makeItemsJson([])
            client.complete(withStatusCode: 200, data: emptyData)
        }
    }
    
    func test_load_deliversItemsOn200HTTPRequestJSONWithItems() {
        let (sut, client) = createSUT()
        let item = makeItem()
        
        expect(sut: sut, toCompleteWith: .success([item.model])) {
            let emptyData = self.makeItemsJson([item.json])
            client.complete(withStatusCode: 200, data: emptyData)
        }
    }

    // MARK: Helpers
    var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    private func makeItem() -> (model: Pokemon, json: [String: Any]) {
        let item = Pokemon(name: "a name", url: anyURL)
        let json: [String : Any] = ["name": item.name, "url": item.url.absoluteString]
        
        return (model: item, json: json)
    }
    
    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        let json = ["results": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(sut: PokemonRemoteLoader,
                        toCompleteWith expectedResult: Result<[Pokemon], PokemonRemoteLoader.Error>,
                        file: StaticString = #file,
                        line: UInt = #line,
                        when action: () -> Void) {
        let exp = expectation(description: "Wait for result")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems)
            case let (.failure(receivedError as PokemonRemoteLoader.Error), .failure(expectedError)):
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
    
    private func createSUT(with url: URL = URL(string: "https://a-url.com")!,
                           file: StaticString = #file, line: UInt = #line) -> (sut: PokemonRemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonRemoteLoader(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut: sut, client: client)
    }
    
}
