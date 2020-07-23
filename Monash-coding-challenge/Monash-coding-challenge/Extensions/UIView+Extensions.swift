//
//  UIView+Extensions.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

/// This Enum dictates  which sides the corner radius should be applied.
enum CornerRadiusSides {
    case all // Adds corner radius to all
    case leftTop
    case leftBottom
    case rightTop
    case rightBottom
    
    var value: CACornerMask {
        switch self {
        case .leftTop:
            return .layerMinXMinYCorner
        case .leftBottom:
            return .layerMinXMaxYCorner
        case .rightTop:
            return .layerMaxXMinYCorner
        case .rightBottom:
            return .layerMaxXMaxYCorner
        case .all:
            return [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
}

extension UIView {
    
    /// Method that will add corner radius to the desired sides using `CornerRadiusSides` enumration. By default it uses `All` which adds  corner radius on all sides
    ///
    /// - Parameters:
    ///   - radius : The amount of radius the value should contain
    ///   - sides   : Using `CornerRadisuSides`, dictates which sides the corner radius should be placed. Defaults to `All`
    func cornerRadius(_ radius: CGFloat, sides: [CornerRadiusSides] = [.all]) {
        self.layer.cornerRadius = radius
        if sides.contains(.all) == false && sides.isEmpty == false {
            // assign it to a var so we can update it
            var updatableSides = sides
            
            // get the first item and remove it. so our corner instance has an initial value
            var corners: CACornerMask = updatableSides.removeFirst().value
            
            // reduce the updatable side instance to fetch the remaining item
            corners = updatableSides.reduce(corners) { (_, next) -> CACornerMask in
                corners.insert(next.value)
                return corners
            }
            self.layer.maskedCorners = corners
        }
    }
    
    /// method that adds a gradient to the current view.
    ///
    /// - Parameters:
    ///  - frame    : The frame of the gradient. Useful if autolayout is being used causing `self.bounds` to be equal to zero. By default it uses `CGRect.zero`
    ///  -  colors : The colors that will be used
    func gradientBackground(frame: CGRect = .zero, colors: [CGColor]) {
        let gradientName = "gradient-background"
        // filter the sublayer making sure gradient is not yet existing
        let gradientlayer = self.layer.sublayers?.filter { $0.name == gradientName }
        // if a gradient background already exist we just skip it
        guard gradientlayer == nil || gradientlayer?.isEmpty == true else { return }
        let gradientLayer = CAGradientLayer()
        // since its auto layout, self.bounds will be zero causing the gradient to not properly display. hence, the additional frame
        gradientLayer.frame = frame == .zero ? self.bounds : frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: -0.5, y: 1)
        gradientLayer.name = gradientName
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Method for adding a shadow to the current view. The opacity of the shadow is set to 0.5 by default.
    ///
    /// - Parameters:
    ///   - offset          : This control the shadow's offset. by default it uses `CGSize.zero`
    ///   - radius          : This controls the radius of the shadow
    ///   - color            : This control the shadow's color. Default it uses `UIColor.black`
    ///   - shadowPath : This optional value can be use if you want to draw the shadow path in a more custom way
    func addShadow(offset: CGSize = .zero, radius: CGFloat, color: UIColor = .black, shadowPath: CGPath? = nil) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5 // lets keep this as the opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowPath = shadowPath
    }
}
