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
    
    func test_didStartLoadingDetailData_displaysNameOnly() {
        let (sut, view) = makeSUT()
        let expectedPokemon = anyPokemon
        
        
        sut.didStartLoadingDetailData(for: expectedPokemon)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, expectedPokemon.name)
        XCTAssertNil(message?.number)
        XCTAssertNil(message?.types)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingDetailData_displaysNameNumberAndType() {
        let transformedData = AnyImage()
        let expectedPokemonDetail = uniqueDetail
        
        let (sut, view) = makeSUT(typeImageTransformer: { _ in transformedData })
        
        sut.didFinishLoadingDetailData(for: expectedPokemonDetail)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, expectedPokemonDetail.name)
        XCTAssertEqual(message?.number, expectedPokemonDetail.id)
        XCTAssertEqual(message?.types?.0, transformedData)
    }
    
    func test_didFinishLoadingDetailWithError_displaysNameNumberAndType() {
        let (sut, view) = makeSUT()
        let expectedPokemon = anyPokemon
        
        sut.didFinishLoadingDetailData(with: anyError, for: expectedPokemon)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, expectedPokemon.name)
        XCTAssertNil(message?.number)
        XCTAssertNil(message?.types)
        XCTAssertNil(message?.image)
    }
    
    // MARK: Helpers
    private var anyPokemon: Pokemon { return Pokemon(name: "any name", url: anyURL)}
    private var uniqueDetail: PokemonDetail { return PokemonDetail(id: "1", name: "any name", types: [Type(name: "any type")]) }
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
                         typeImageTransformer: @escaping (String?) -> AnyImage? = { _ in nil },
                         file: StaticString = #file, line: UInt = #line) -> (sut: PokemonDetailPresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = PokemonDetailPresenter(view: view,
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
