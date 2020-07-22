//
//  BaseTableViewCell.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }
    
    private func setupSelf() {
        
    }
}
