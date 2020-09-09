//
//  PokemonTableView.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

class PokemonTableView: UITableView {
    
    private let sectionSpacing: CGFloat = 0
    private let cellHeight: CGFloat = 75
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        rowHeight = cellHeight
        sectionHeaderHeight = sectionSpacing
        
        register(cellType: PokemonTableViewCell.self)
    }
}
