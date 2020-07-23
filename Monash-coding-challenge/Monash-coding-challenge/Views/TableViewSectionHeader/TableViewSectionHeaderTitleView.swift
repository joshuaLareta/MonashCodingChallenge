//
//  TableViewSectionHeaderTitleView.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class TableviewSectionHeaderTitleView: UITableViewHeaderFooterView {
  
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .gray
        return title
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }
    
    /// This method configure what the intial look of this view is
    private func setupSelf() {
        self.contentView.addSubview(title)
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-13-[title]-15-|",
                                                                       options: [],
                                                                       metrics: nil,
                                                                       views: ["title": title]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[title]-8-|",
                                                                       options: [],
                                                                       metrics: nil,
                                                                       views: ["title": title]))
    }
}

extension TableviewSectionHeaderTitleView {
    func update(title: String?) {
        self.title.text = title
    }
}
