//
//  RemotePokemonImageLoader.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/9/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public class RemotePokemonImageLoader: PokemonImageLoader {
    
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageData(with url: URL, completion: @escaping (PokemonImageLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.failure(Error.invalidData))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
