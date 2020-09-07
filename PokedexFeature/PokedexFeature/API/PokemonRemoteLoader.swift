//
//  PokemonRemoteLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(response: HTTPURLResponse, data: Data), Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public class PokemonRemoteLoader: PokemonLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    private static var OK_200: Int { return 200 }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (PokemonLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success((let httpResponse, let data)):
                completion(PokemonRemoteLoader.map(httpResponse: httpResponse, data: data))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private struct Root: Decodable {
        private var results: [RemotePokemon]
        
        var pokemons: [Pokemon] {
            return results.map{ $0.pokemon }
        }
    }
    
    private struct RemotePokemon: Decodable {
        var name: String
        var url: URL
        
        var pokemon: Pokemon {
            return Pokemon(name: name, url: url)
        }
    }
    
    static private func map(httpResponse: HTTPURLResponse, data: Data) -> PokemonLoader.Result {
        guard httpResponse.statusCode == PokemonRemoteLoader.OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(PokemonRemoteLoader.Error.invalidData)
        }
        
        return .success(root.pokemons)
    }
    
}
