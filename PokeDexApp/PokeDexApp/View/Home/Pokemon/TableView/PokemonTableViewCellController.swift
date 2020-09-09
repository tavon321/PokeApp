//
//  PokemonTableViewCellController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

public protocol PokemonTableViewCellControllerDelegate {
    func didRequestDetail(for pokemon: Pokemon)
    func didCancelDataRequest()
}

public class PokemonTableViewCellController: PokemonDetailView {

    private let pokemon: Pokemon
    private var cell: PokemonTableViewCell?
    private let delegate: PokemonTableViewCellControllerDelegate
    
    public init(pokemon: Pokemon, delegate: PokemonTableViewCellControllerDelegate) {
        self.pokemon = pokemon
        self.delegate = delegate
    }
    
    func name() -> String {
        return pokemon.name
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.nibId) as? PokemonTableViewCell else {
            fatalError("PokemonTableViewCell couldn't be initialized")
        }
        
        self.cell = cell
        self.delegate.didRequestDetail(for: pokemon)
        
        return cell
    }
    
    public func display(_ model: PokemonDetailViewModel<UIImage>) {
        DispatchQueue.main.async { [unowned self] in
            self.cell?.set(title: model.name)
            self.cell?.set(number: model.number)
            self.cell?.set(elementImages: model.types)
            self.cell?.set(image: model.image)
        }
    }
    
    func cancelLoad() {
        cell = nil
        delegate.didCancelDataRequest()
    }
}

extension PokemonTableViewCellController: Equatable, Hashable {
    public static func == (lhs: PokemonTableViewCellController, rhs: PokemonTableViewCellController) -> Bool {
        return lhs.pokemon == rhs.pokemon
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pokemon.name)
        hasher.combine(pokemon.url)
    }
}
