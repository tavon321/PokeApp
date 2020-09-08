//
//  PokemonDetailPresenterTests.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import XCTest
import PokedexFeature

class PokemonDetailPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: Helpers
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
                         typeImageTransformer: @escaping (String) -> AnyImage? = { _ in nil },
                         file: StaticString = #file, line: UInt = #line) -> (sut: PokemonImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = PokemonImagePresenter(view: view,
                                        typeImageTransformer: typeImageTransformer,
                                        imageTransformer: imageTransformer)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private struct AnyImage: Equatable {}
    
    private class ViewSpy: PokemonDetailView {
        private(set) var messages = [PokemonDetailViewModel<AnyImage>]()
        
        func display(_ model: PokemonDetailViewModel<AnyImage>) {
            messages.append(model)
        }
        
    }
}
