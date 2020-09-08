//
//  PokemonTableViewCellController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

public class PokemonTableViewCellController: Equatable, Hashable  {

    private let pokemon: Pokemon
    private var cell: PokemonTableViewCell!
    
    public init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.nibId) as? PokemonTableViewCell else {
            fatalError("PokemonTableViewCell couldn't be initialized")
        }
        
        self.cell = cell
        cell.set(title: pokemon.name)
        return cell
    }
    
    public static func == (lhs: PokemonTableViewCellController, rhs: PokemonTableViewCellController) -> Bool {
        return lhs.pokemon == rhs.pokemon
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pokemon.name)
        hasher.combine(pokemon.url)
    }
}
