//
//  NavigationController+Extensions.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

extension UINavigationController {
    /// Method for hiding the hairline on a navigation controller. This makes the navigation bar opaque
    ///
    /// This uses an "empty" image that is set to the background and shadow of the navigation bar
    func hideHairline() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
