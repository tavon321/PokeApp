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
        client.get(from: url) { result in
            switch result {
            case .success((let response, let data)):
                completion(PokemonDetailMapper.map(response: response, data: data))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}


class PokemonDetailMapper {
    
    private struct RemotePokemonDetail: Decodable {
        var id: String
        var name: String
        var types: [RemoteType]
        
        var pokemonDetail: PokemonDetail {
            return PokemonDetail(id: id, name: name, types: types.map({ $0.type }))
        }
    }
    
    private struct RemoteType: Decodable {
        var name: String
        
        var type: Type { return Type(name: name)}
    }
    
    static func map(response: HTTPURLResponse, data: Data) -> PokemonDetailLoader.Result {
        guard response.isOK, let remoteDetail = try? JSONDecoder().decode(RemotePokemonDetail.self, from: data) else { return .failure(PokemonDetailRemoteLoader.Error.invalidData)}
        
        return .success(remoteDetail.pokemonDetail)
    }
}
