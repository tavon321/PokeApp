//
//  PokemonMapper.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

struct PokemonMapper {
    
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
    
    static func map(httpResponse: HTTPURLResponse, data: Data) -> PokemonLoader.Result {
        guard httpResponse.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(PokemonRemoteLoader.Error.invalidData)
        }
        
        return .success(root.pokemons)
    }
}
