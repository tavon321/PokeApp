//
//  PokemonErrorView.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

class PokemonErrorView: UIView {
    
    @IBOutlet private var detailTilte: UILabel!
    
    var retryButtonTappedCompletion: ((_ sender: UIButton) -> Void)?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        retryButtonTappedCompletion?(sender)
    }
}
