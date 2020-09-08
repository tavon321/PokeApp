//
//  Storyboard+instanitate.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case splashStoryboard = "Splash"
    case homeStoryboard = "Home"
}

/// Create `Viewcontroller` from a storyboard
protocol Storyboarded {
    static func instantiate(with storyBoard: Storyboard) -> Self?
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(with storyBoard: Storyboard) -> Self? {
        let className = String(describing: Self.self)

        // load our storyboard
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as? Self
    }
}
