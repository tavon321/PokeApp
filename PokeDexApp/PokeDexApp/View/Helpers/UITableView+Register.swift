//
//  UITableView+Register.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var nibId: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        let bundle = Bundle(for: cellType)
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: nibName)
    }
}
