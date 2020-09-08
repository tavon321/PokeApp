//
//  PokemonDataSource.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

final class PokemonDataSource: UITableViewDiffableDataSource<PokemonTableViewCellController, PokemonTableViewCellController> {
    typealias PokemonClosure = ([PokemonTableViewCellController]) -> Void
    
    private var controllers: [PokemonTableViewCellController] = []
    
    convenience init(tableView: UITableView, getPokemons: (PokemonClosure) -> Void) {
        self.init(tableView: tableView) { (tableView, indexPath, controller) -> UITableViewCell? in
            return controller.view(in: tableView)
        }
        
        getPokemons { [weak self] controllers in
            self?.controllers = controllers
            DispatchQueue.main.async {
                self?.applySnapshot(with: controllers)
            }
        }
    }
    
    func applySnapshot(with controllers: [PokemonTableViewCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<PokemonTableViewCellController, PokemonTableViewCellController>()
        
        snapshot.appendSections(controllers)
        controllers.forEach { controller in
            snapshot.appendItems([controller], toSection: controller)
        }

        self.apply(snapshot, animatingDifferences: false)
    }
}
