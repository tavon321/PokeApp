//
//  PokemonsViewController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

final class PokemonsViewController: UIViewController, Storyboarded {
    
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureToolbar()
        configureSearchController()
    }
    
    private func configureNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func configureToolbar() {
        let tabBarTitle = "Pokemon"
        let barButtonItem = UITabBarItem(title: tabBarTitle, image: #imageLiteral(resourceName: "pokemon-tab-icon"), tag: 0)
        tabBarItem = barButtonItem
    }
}

