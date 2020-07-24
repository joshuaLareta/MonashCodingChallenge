//
//  InfoView.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

/// A View class that contains a main title and a subtitle
class InfoView: UIView {
    let mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        mainTitle.textColor = .black
        mainTitle.setContentHuggingPriority(.required, for: .vertical)
        mainTitle.setContentCompressionResistancePriority(.required, for: .vertical)
        return mainTitle
    }()
    
    let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        subTitle.textColor = .gray
        subTitle.setContentHuggingPriority(.required, for: .vertical)
        subTitle.setContentCompressionResistancePriority(.required, for: .vertical)
        return subTitle
    }()
    
    /// If we use this initializer we already assume that its going to use autolayout.
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupSelf()
    }
    
    /// If we want to intialized it using a frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }
    
    private func setupSelf() {
        self.addSubview(mainTitle)
        self.addSubview(subTitle)
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Setup main title horizontal constraints
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainTitle]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["mainTitle": mainTitle]))
        // Setup subtitle horizontal constraints
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subTitle]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["subTitle": subTitle]))
        
        // Setup mainTitle and subTitle vertical constraints. We added a top padding of 5 and a >= 5 for the bottom. The Superview might control the total height so we added a bottom padding of >=5 eliminating the constraint conflicts.
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[mainTitle]-5-[subTitle]->=5-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["mainTitle": mainTitle, "subTitle": subTitle]))
    }
}

extension InfoView {
    public func update(title: String?, subTitle: String?) {
        self.mainTitle.text = title
        self.subTitle.text = subTitle
    }
}
