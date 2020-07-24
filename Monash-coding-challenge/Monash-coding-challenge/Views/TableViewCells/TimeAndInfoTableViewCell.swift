//
//  TimeAndInfoTableViewCell.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class TimeAndInfoTableViewCell: BaseTableViewCell {
    
    private struct Constant {
        static let dateStackMinWidth: CGFloat = 40
    }
    
    private var dateStackWidthConstraints: NSLayoutConstraint!
    
    let startTime: UILabel = {
        let startTime = UILabel()
        startTime.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return startTime
    }()
    
    let endTime: UILabel = {
        let endTime = UILabel()
        endTime.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return endTime
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return title
    }()
    
    let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.numberOfLines = 0
        subTitle.lineBreakMode = .byWordWrapping
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subTitle.setContentHuggingPriority(.required, for: .horizontal)
        subTitle.setContentCompressionResistancePriority(.required, for: .horizontal)
        return subTitle
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.separatorColor.withAlphaComponent(0.8)
        separator.cornerRadius(1)
        return separator
    }()
    
    let dateStack: UIStackView = {
        let dateStack = UIStackView()
        dateStack.translatesAutoresizingMaskIntoConstraints = false
        dateStack.alignment = .leading
        dateStack.distribution = .fill
        dateStack.axis = .vertical
        dateStack.spacing = 5
        return dateStack
    }()
    
    let infoStack: UIStackView = {
        let infoStack = UIStackView()
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.alignment = .leading
        infoStack.distribution = .fill
        infoStack.axis = .vertical
        infoStack.spacing = 5
        return infoStack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSelf()
    }

    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }
    
    private func setupSelf() {
        dateStack.addArrangedSubview(startTime)
        dateStack.addArrangedSubview(endTime)
        
        infoStack.addArrangedSubview(title)
        infoStack.addArrangedSubview(subTitle)
        self.containerView.addSubview(dateStack)
        self.containerView.addSubview(separator)
        self.containerView.addSubview(infoStack)
        setupConstraints()

    }
    
    // Sets up the view's contraints
    private func setupConstraints() {
        // we are using the containerView instead of the contentView as we want to have the left and right padding without affecting the natural behaviour of content
        
        // This sets the dateStack, separator, and info stack's horizontal layout
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[dateStack]-5-[separator(==2.5)]-20-[infoStack]->=20-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["dateStack": dateStack, "separator": separator, "infoStack": infoStack]))
        // This controls the dateStack's width. By default uses the `Constant.dateStackMinWidth`
        self.dateStackWidthConstraints = NSLayoutConstraint(item: dateStack,
                                                            attribute: .width,
                                                            relatedBy: .greaterThanOrEqual,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1,
                                                            constant: Constant.dateStackMinWidth)
        dateStack.addConstraint(self.dateStackWidthConstraints)
        
        // We add the vertical constraints for the separator, having a top and bottom of 10
         self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[separator]-10-|",
                                                                          options: [],
                                                                          metrics: nil,
                                                                          views: ["separator": separator]))
        
        // This controls the dateStack's center constraints.
        self.containerView.addConstraint(NSLayoutConstraint(item: dateStack,
                                                            attribute: .centerY,
                                                            relatedBy: .equal,
                                                            toItem: self.containerView,
                                                            attribute: .centerY,
                                                            multiplier: 1,
                                                            constant: 0))
        // We still need to add a dateStack's vertical constraints so that if infoStack or other elements cannot push the view the dateStack and still control the container view's height. This makes sure that dateStack has atleast 2 padding for top and bottom
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=2-[dateStack]->=2-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["dateStack": dateStack]))
        
        // We set the infoStack's vertical constraints having a 10 on top and 15 bottom
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[infoStack]-15-|",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["infoStack": infoStack]))
    }
}

extension TimeAndInfoTableViewCell {
    /// Method that readjust the dateStack's width. This is an already existing constraints.
    ///
    /// If you call this before cell returns in `CellForRow:` this should work as expected. If the cell has already returned, the cell's other constraints are already in placed for this to refresh you need to call a reload on the tableview to make sure it reinitialized all the constraints again
    func updateCellDistribution(width: CGFloat) {
          self.dateStackWidthConstraints.constant = width * 0.22 // get the 22% of the container's frame
    }
    
    func prettifySubTitle(_ subtitle: String?) -> NSAttributedString? {
        guard let subtitle = subtitle else { return nil }
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
      
        return NSAttributedString(string: subtitle, attributes: [.paragraphStyle: paragraph])
        
    }
    
    /// Method that updates the elements content
    ///
    /// - Parameters:
    ///  - start        : This text will be assigned to the start time label. This is not  necessary be a time value
    ///  - end            : This will be assigned to the end time label. This is not  necessary be a time value
    ///  - title        : This will be assigned to the title label. Title label is displayed in a System Bold Format
    ///  - subTitle : This will be assigned to the Subtitle label
    func update(start: String?, end: String?, title: String?, subTitle: String?) {
        self.startTime.text = start
        self.endTime.text = end
        self.title.text = title
        
        if let sub = subTitle {
            self.subTitle.attributedText = prettifySubTitle(sub)
        } else {
            self.subTitle.text = nil
            self.subTitle.attributedText = nil
        }
    }
}
