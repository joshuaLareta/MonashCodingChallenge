//
//  TableViewSectionHeaderView.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class TableViewSectionHeaderView: UITableViewHeaderFooterView {
    private struct Constant {
        static let cornerRadius: CGFloat = 5
    }
    
    // This will be our main "content view" to hold all elements
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        return containerView
    }()
    
    let bannerContainer: UIView = {
        let bannerContainer = UIView()
        bannerContainer.translatesAutoresizingMaskIntoConstraints = false
        bannerContainer.clipsToBounds = true
        bannerContainer.cornerRadius(Constant.cornerRadius, sides: [.rightBottom])
        return bannerContainer
    }()
    
    let banner: UILabel = {
        let banner = UILabel()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.font = UIFont.boldSystemFont(ofSize: 16)
        banner.textColor = .white
        banner.textAlignment = .center
        banner.text = "Today".uppercased()
        banner.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        banner.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        banner.setContentHuggingPriority(.defaultHigh, for: .vertical)
        banner.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return banner
    }()
    
    let moreOptionButton: UIButton = {
        let moreOptionButton = UIButton(type: .custom)
        moreOptionButton.translatesAutoresizingMaskIntoConstraints = false
        moreOptionButton.setImage(UIImage(systemName: "ellipsis")?.withTintColor(UIColor.gray.withAlphaComponent(0.7), renderingMode: .alwaysOriginal), for: .normal)
        
        return moreOptionButton
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
        containerView.cornerRadius(Constant.cornerRadius, sides: [.leftTop, .rightTop])
        bannerContainer.addSubview(banner)
        // add the banner contianer to the main container view
        containerView.addSubview(bannerContainer)
        // add the more otion button to the main container view
        containerView.addSubview(moreOptionButton)
        self.contentView.addSubview(containerView)
        setupConstraints()
        setupContainerConstraints()
        setupBannerContainer()
    }
    
    private func setupConstraints() {
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-13-[containerView]-15-|",
                                                                       options: [],
                                                                       metrics: nil,
                                                                       views: ["containerView": containerView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|",
                                                                       options: [],
                                                                       metrics: nil,
                                                                       views: ["containerView": containerView]))
    }
    
    /// Method for setting up constraints/layout for elements inside the container view
    private func setupContainerConstraints() {
        // configure the horizontal aspect of the bannerContainer and more option button
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bannerContainer(>=80)]->=5-[moreOptionButton]-10-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["bannerContainer": bannerContainer, "moreOptionButton": moreOptionButton]))
        // configure the bannerContainer vertical aspect
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bannerContainer(>=30@750)]->=0-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["bannerContainer": bannerContainer]))
        
        // We need to center the more option button inside the container view
        self.containerView.addConstraint(NSLayoutConstraint(item: moreOptionButton,
                                                            attribute: .centerY,
                                                            relatedBy: .equal,
                                                            toItem: self.containerView,
                                                            attribute: .centerY,
                                                            multiplier: 1,
                                                            constant: 0))
        
        // We add additional constraints for the more option button so if banner is so small we still have a 5 to top and bottom padding
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=5-[moreOptionButton]->=5-|",
                                                                        options: [],
                                                                        metrics: nil,
                                                                        views: ["moreOptionButton": moreOptionButton]))
    }
    
    private func setupBannerContainer() {
        self.bannerContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[banner]-2-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: ["banner": banner]))
        self.bannerContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[banner]-5-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: ["banner": banner]))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // since we want to make sure that the element has already rendered it's frame we will add the gradient after the draw method
        bannerContainer.gradientBackground(colors: [#colorLiteral(red: 0.8308809996, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.72).cgColor, UIColor.backgroundColor.cgColor])
    }
}
