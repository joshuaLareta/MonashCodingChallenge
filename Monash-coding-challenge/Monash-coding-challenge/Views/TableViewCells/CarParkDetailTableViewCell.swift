//
//  CarParkDetailTableViewCell.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class CarParkDetailTableViewCell: BaseTableViewCell {
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "asdf"
        return title
    }()
    
    let colorContainer: UIView = {
        let colorContainer = UIView()
        colorContainer.translatesAutoresizingMaskIntoConstraints = false
        return colorContainer
    }()
    
    let total: UILabel = {
        let total = UILabel()
        total.translatesAutoresizingMaskIntoConstraints = false
        total.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        total.textColor = .separatorColor
        return total
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }
       
    private func setupSelf() {
        self.containerView.addSubview(title)
        self.containerView.addSubview(colorContainer)
        self.containerView.addSubview(total)
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.containerView.addConstraint(NSLayoutConstraint(item: colorContainer,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: self.containerView,
                                                            attribute: .centerX,
                                                            multiplier: 1,
                                                            constant: 50))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[title]->=10-[colorContainer]->=5-[total]-20-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["title": title, "colorContainer": colorContainer, "total": total]))
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[title]-10-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["title": title]))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[colorContainer]-10-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["colorContainer": colorContainer]))
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[total]-10-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["total": total]))
    }
}

extension CarParkDetailTableViewCell {
    /// Private method that just gives out a random Float
    /// - Returns: Random float
    private var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    /// Method that creates a dynamic View, let's just call it colorView
    /// - Returns: Returns a new instance of a view
    private func createColorView() -> UIView {
        let color = UIView()
        color.translatesAutoresizingMaskIntoConstraints = false
        color.cornerRadius(6)
        color.backgroundColor = UIColor(red: random, green: random, blue: random, alpha: 1)
        return color
    }
    
    /// Method That adds the dynmic view to the color container
    ///
    /// - Parameters:
    ///   - viewName  : Name of the View element
    ///   - color         : The instance of the view
    private func setupColorVerticalConstraints(viewName: String, color: UIView) {
        colorContainer.addConstraint(NSLayoutConstraint(item: color,
                                                        attribute: .centerY,
                                                        relatedBy: .equal,
                                                        toItem: colorContainer,
                                                        attribute: .centerY,
                                                        multiplier: 1,
                                                        constant: 0))
        
        colorContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|->=2-[\(viewName)(==12)]->=2-|",
            options: [],
            metrics: nil,
            views: [viewName: color]))
    }
    
    /// Method that populates the color in the color container view.
    private func showPercentageViaColor(available: Float, total: Float, healthCheckValue: Int) {
        for v in colorContainer.subviews { v.removeFromSuperview() }
        
        guard total >= available,
            healthCheckValue > 0  else { return }
        
        var horizontal: String = "H:|-5-"
        var views: [String: Any] = [:]
        
        // dynamically create views. Not the prettiest implementation
        for i in 0..<healthCheckValue {
            let color = self.createColorView()
            colorContainer.addSubview(color)
            // create a name based on the String
            let viewName = "v" + String(i)
            // merge cell and if there are conflict use the latest one
            views.merge([viewName: color], uniquingKeysWith: { return $1 })
        
            horizontal += "[\(viewName)(==12)]"
            if i == (healthCheckValue - 1){ // last cell
                horizontal += "-5-|"
            } else {
                horizontal += "-5-"
            }
            setupColorVerticalConstraints(viewName: viewName, color: color)
        }
        colorContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontal, options: [], metrics: nil, views: views))
    }
}

extension CarParkDetailTableViewCell {
    func update(name: String?, available: Int, total: Int, healthCheck: Int) {
        self.title.text = name
        // let's process the data by showing colors that will represent availability
        showPercentageViaColor(available: Float(available), total: Float(total), healthCheckValue: healthCheck )
        self.total.text = String(total)
    }
}
