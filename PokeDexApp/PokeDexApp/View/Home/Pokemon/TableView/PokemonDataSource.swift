//
//  PokemonDataSource.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

final class PokemonDataSource: UITableViewDiffableDataSource<Int, PokemonTableViewCellController> {
    
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
        var snapshot = NSDiffableDataSourceSnapshot<Int, PokemonTableViewCellController>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(controllers)
        
        self.apply(snapshot, animatingDifferences: false)
    }
    
    func filteredSections(for query: String?)  {
        guard let query = query, !query.isEmpty else {
            applySnapshot(with: self.controllers)
            return
        }
        
        let filteredControllers = self.controllers.filter { controller -> Bool in
            return controller.name().lowercased().contains(query.lowercased())
        }
        
        applySnapshot(with: filteredControllers)
    }
}
