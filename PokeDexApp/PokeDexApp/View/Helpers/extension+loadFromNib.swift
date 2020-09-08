//
//  extension+loadFromNib.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

extension UIView {
    func loadFromNib() -> Self? {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)

        return nib.instantiate(withOwner: self, options: nil).first as? Self
    }
}
