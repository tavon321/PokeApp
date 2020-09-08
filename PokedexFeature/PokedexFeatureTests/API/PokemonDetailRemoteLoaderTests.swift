//
//  PokemonDetailRemoteLoaderTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

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
    
    func test_load_deliversInvalidDataErrorOnNon200HttpRespone() {
        let (sut, client) = createSUT()

        let samples = [199, 201, 300, 400, 500].enumerated()

        samples.forEach { index, code in
            expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
                let data = Data("".utf8)
                client.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }
    
    func test_load_deliversItemOn200HTTPResponseWithJSONItem() {
        let (sut, client) = createSUT()
        let item = makeItem()
        
        expect(sut: sut, toCompleteWith: .success(item.model)) {
            let data = self.makeItemJson(item.json)
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_laod_doesNotDeliverResultOnSUTDeallocation() {
        let client = HTTPClientSpy()
        var sut: PokemonDetailRemoteLoader? = PokemonDetailRemoteLoader(client: client)
        
        var capturedResult: PokemonDetailLoader.Result?
        sut!.loadDetail(with: anyURL) { result in
            capturedResult = result
        }
        
        sut = nil
        client.complete(withStatusCode: 200, data: Data())
        
        XCTAssertNil(capturedResult)
    }
    
    // MARK: Helpers
    private var anyURL: URL { return URL(string: "https://a-url.com")! }
    
    private func makeItemJson(_ item: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: item)
    }
    
    private func makeItem() -> (model: PokemonDetail, json: [String: Any]) {
        let type = Type(name: "a type")
        let item = PokemonDetail(id: "1", name: "a name", types: [type])
        let json: [String : Any] = ["id": Int(item.id)!,
                                    "name": item.name,
                                    "types": [["type": ["name": type.name]]]]
        
        return (model: item, json: json)
    }
    
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
    
}
