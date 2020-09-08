//
//  PokemonDetailMapper.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

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
