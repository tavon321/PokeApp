//
//  HTTPClientSpy.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation
import PokedexFeature
import XCTest

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
