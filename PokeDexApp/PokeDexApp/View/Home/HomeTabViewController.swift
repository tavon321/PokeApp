//
//  HomeTabViewController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

final class HomeTabViewController: UITabBarController, Storyboarded {

    var dependencyHandler: HomeDependencyManager!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokemon"
        configureNavBar()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTabBarControllers()
    }
    
    private func configureSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func configureTabBarControllers() {
        viewControllers = [pokemonsViewController]
    }
    
    private lazy var pokemonsViewController: PokemonsViewController = {
        let controller = PokemonUIComposer.pokemonsViewController(with: dependencyHandler)
        controller.searchController = searchController
        
        return controller
    }()
}
