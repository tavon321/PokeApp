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
    
    // MARK: - UI
    @IBOutlet private var containerView: UIView!
    private var searchController: UISearchController!
    private var tableViewDataSource: UITableViewDataSource?
    
    // MARK: - Dependencies
    private var delegate: PokemonViewControllerDelegate?
    
    // MARK: - Views
    private lazy var errorView: PokemonErrorView = {
        let errorView = PokemonErrorView().loadFromNib()!
        errorView.retryButtonTappedCompletion = { [unowned self] _ in
            self.refresh()
        }
        
        setConstraintsFor(for: errorView)
        
        return errorView
    }()
    
    private lazy var tableView: PokemonTableView = {
        let tableView = PokemonTableView()
        setConstraintsFor(for: tableView, multipliyer: 1)
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
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
    
    // MARK: - Helpers
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
        let controllers = viewModel.list.compactMap { pokemon in
            return PokemonTableViewCellController(pokemon: pokemon)
        }
        
        self.tableViewDataSource = PokemonDataSource(tableView: tableView, getPokemons: { closure in
            closure(controllers)
        })
        tableView.dataSource = tableViewDataSource
    }
}

extension PokemonsViewController: PokedexFeature.PokemonErrorView {
    func display(_ viewModel: PokemonErrorViewModel) {
        guard let errorMessage = viewModel.message else {
            errorView.isHidden = true
            return
        }
        
        errorView.isHidden = false
        errorView.detailTilte.text = errorMessage
    }
}

extension PokemonsViewController: PokemonLoadingView {
    func display(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
    }
}
