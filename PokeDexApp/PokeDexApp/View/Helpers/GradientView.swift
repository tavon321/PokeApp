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
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0)
        (layer as! CAGradientLayer).endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
        (layer as! CAGradientLayer).locations = [0, 0.35, 0.75, 1]
        (layer as! CAGradientLayer).colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor, forthColor.cgColor]
    }
}
