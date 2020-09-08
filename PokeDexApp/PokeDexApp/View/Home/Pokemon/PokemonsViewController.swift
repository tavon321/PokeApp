//
//  PokemonsViewController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit
import PokedexFeature

final class PokemonsViewController: UIViewController, Storyboarded {
    
    @IBOutlet private var containerView: UIView!
    
    private var searchController: UISearchController!
    private var delegate: PokemonViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureToolbar()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
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
    
    private func refresh() {
        delegate?.didRequestPokemonData()
    }
    
    private func setConstraintsFor(for informationView: UIView, multipliyer: CGFloat = 0.9) {
        containerView.addSubview(informationView)
        
        informationView.translatesAutoresizingMaskIntoConstraints = false
        informationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        informationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        informationView.heightAnchor.constraint(equalToConstant: containerView.bounds.height).isActive = true
        informationView.widthAnchor.constraint(equalToConstant: containerView.bounds.width * multipliyer).isActive = true
    }
}

extension PokemonsViewController: PokemonView {
    func display(_ viewModel: PokemonListViewModel) {
        
    }
}

extension PokemonsViewController: PokedexFeature.PokemonErrorView {
    
    func display(_ viewModel: PokemonErrorViewModel) {
        guard let infoView = PokemonErrorView().loadFromNib() else {
            fatalError("The ErrorStateView should be loaded from NIB")
        }
        
        infoView.retryButtonTappedCompletion = { [unowned self] _ in
            self.refresh()
        }
        
        setConstraintsFor(for: infoView)
    }
}

extension PokemonsViewController: PokemonLoadingView {
    func display(_ isLoading: Bool) {
    }
}
