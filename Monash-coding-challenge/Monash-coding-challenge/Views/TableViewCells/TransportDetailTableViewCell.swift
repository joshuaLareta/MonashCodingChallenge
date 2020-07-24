//
//  TransportDetailTableViewCell.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class TransportDetailTableViewCell: BaseTableViewCell {
    
    private struct Constant {
        static let imageDimension: CGFloat = 18
        static let padding: CGFloat = 20
    }

    let from: UILabel = {
        let from = UILabel()
        from.translatesAutoresizingMaskIntoConstraints = false
        from.numberOfLines = 0
        from.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        from.lineBreakMode = .byWordWrapping
        return from
    }()
    
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "busRoute")
        return icon
    }()
    
    let to: UILabel = {
        let to = UILabel()
        to.translatesAutoresizingMaskIntoConstraints = false
        to.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return to
    }()
    
    let travelTime: UILabel = {
        let travelTime = UILabel()
        travelTime.translatesAutoresizingMaskIntoConstraints = false
        travelTime.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        travelTime.textColor = .separatorColor
        return travelTime
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }

    private func setupSelf() {
        self.containerView.addSubview(from)
        self.containerView.addSubview(icon)
        self.containerView.addSubview(to)
        self.containerView.addSubview(travelTime)
        setupConstraints()
    }

    private func setupConstraints() {
        let metrics: [String: CGFloat] = ["imgDimension": Constant.imageDimension, "topBotPadding": Constant.padding]
        self.containerView.addConstraint( NSLayoutConstraint(item: icon, attribute: .centerX, relatedBy: .equal, toItem: self.containerView, attribute: .centerX, multiplier: 1, constant: -80))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[from]-5-[icon(==imgDimension)]-20-[to]->=10-[travelTime]-20-|",
                                                                         options: [.alignAllCenterY],
                                                                         metrics: metrics,
                                                                         views: ["from": from, "icon": icon, "to": to, "travelTime": travelTime]))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=topBotPadding-[from]->=topBotPadding-|",
                                                                                options: [],
                                                                                metrics: metrics,
                                                                                views: ["from": from]))
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=topBotPadding-[to]->=topBotPadding-|",
                                                                         options: [],
                                                                         metrics: metrics,
                                                                         views: ["to": to]))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=topBotPadding-[icon(==imgDimension)]->=topBotPadding-|",
                                                                         options: [],
                                                                         metrics: metrics,
                                                                         views: ["icon": icon]))
    }
}

extension TransportDetailTableViewCell {
    
    func update(from: String?, to: String?, travelTime: String?) {
        self.from.text = from
        self.to.text = to
        self.travelTime.text = travelTime
    }
}
