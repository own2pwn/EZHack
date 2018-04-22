//
//  UIView+Gradient.swift
//  rxHealth
//
//  Created by Evgeniy on 03.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func applyGradient(with colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = frame
        gradientLayer.frame.origin = .zero
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func applyGradient(with colors: UIColor...) {
        applyGradient(with: colors)
    }
    
    public func applyGradientSecondWay(with colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = frame
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
