//
//  PokemonDetailRemoteLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public class PokemonDetailRemoteLoader: PokemonDetailLoader {
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadDetail(with url: URL, completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success((let response, let data)):
                completion(PokemonDetailMapper.map(response: response, data: data))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
