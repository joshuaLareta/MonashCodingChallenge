//
//  IdentifiableProtocol.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

/// Protocol that  just have a static property called `identifier`. It's upto the developer on how they give the identity of the element/object.
protocol IdentifiableProtocol {
    static var identifier: String { get }
}

// Helper implementation of IdentifableProtocol which are of View type
extension IdentifiableProtocol where Self: UIView {
  static var identifier: String {
        return String(describing: self)
    }
}
