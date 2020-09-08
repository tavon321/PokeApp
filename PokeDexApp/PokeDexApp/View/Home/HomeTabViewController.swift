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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokemon"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTabBarControllers()
    }
    
    private func configureTabBarControllers() {
        viewControllers = [pokemonsViewController]
    }
    
    private lazy var pokemonsViewController: PokemonsViewController = {
        return PokemonUIComposer.pokemonsViewController(with: dependencyHandler)
    }()
}
