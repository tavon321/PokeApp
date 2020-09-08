//
//  HomeTabViewController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokemon"
        configureTabBarControllers()
    }
    
    private func configureTabBarControllers() {
        viewControllers = [pokemonsViewController]
    }
    
    private lazy var pokemonsViewController: PokemonsViewController = {
        let controller = PokemonsViewController.instantiate(with: .homeStoryboard)!
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        return controller
    }()
}
