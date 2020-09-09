//
//  UppercasedFirstTests.swift
//  PokeDexAppTests
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
@testable import PokedexFeature

class UppercasedFirstTests: XCTestCase {
    
    func test_uppercasingFirst_returnsStringUppercased() {
        let sut = "undercased text"
        let expectedString = "Undercased text"
        
        XCTAssertEqual(sut.uppercasingFirst, expectedString)
    }
}
