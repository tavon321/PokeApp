//
//  GradientView.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.red
    @IBInspectable var thirdColor: UIColor = UIColor.blue
    @IBInspectable var forthColor: UIColor = UIColor.purple
    
    @IBInspectable var vertical: Bool = true
    @IBInspectable var blur: Bool = true
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
        layer.locations = [0, 0.35, 0.75, 1]
        layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor, forthColor.cgColor]
        
        if blur {
            addBlur()
        }
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
}
