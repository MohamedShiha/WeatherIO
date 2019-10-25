//
//  GradientView.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/24/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class GradientView: UIView {

    /* Overriding default layer class to use CAGradientLayer */
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    /* Handy accessor to avoid unnecessary casting */
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    /* Public properties to manipulate colors */
    public var firstColor: UIColor = UIColor.white {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![0] = firstColor.cgColor
            gradientLayer.colors = currentColors
        }
    }
    
    public var secondColor: UIColor = UIColor.white {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![1] = secondColor.cgColor
            gradientLayer.colors = currentColors
        }
    }
    
    public var thirdColor: UIColor = UIColor.white {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![2] = thirdColor.cgColor
            gradientLayer.colors = currentColors
        }
    }
    
    /* Initializers overriding to have appropriately configured layer after creation */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    func setupGradient () {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.75)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.25)
    }
}

