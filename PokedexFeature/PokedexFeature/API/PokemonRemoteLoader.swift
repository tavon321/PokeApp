//
//  PokemonRemoteLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public class PokemonRemoteLoader: PokemonLoader {
    
    private let url: URL
    private let client: HTTPClient
    
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
                completion(PokemonMapper.map(httpResponse: httpResponse, data: data))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
