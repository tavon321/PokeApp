//
//  SplashViewController.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController, Storyboarded {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self, let homeViewController = HomeNavViewController.instantiate(with: .homeStoryboard) else { return }
            homeViewController.modalPresentationStyle = .overFullScreen
            self.present(homeViewController, animated: true)
        }
    }
}
