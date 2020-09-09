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
        var id: Int
        var name: String
        var types: [RemoteTypeContainer]
        
        var pokemonDetail: PokemonDetail {
            return PokemonDetail(id: String(id), name: name, types: types.map({ $0.type.type }))
        }
    }
   
    private struct RemoteTypeContainer: Decodable {
        var type: RemoteType
    }
    
    private struct RemoteType: Decodable {
        var name: String
        
        var type: Type { return Type(name: name) }
    }
    
    static func map(response: HTTPURLResponse, data: Data) -> PokemonDetailLoader.Result {
        guard response.isOK, let remoteDetail = try? JSONDecoder().decode(RemotePokemonDetail.self, from: data) else {
            return .failure(PokemonDetailRemoteLoader.Error.invalidData)
        }
        
        return .success(remoteDetail.pokemonDetail)
    }
}
