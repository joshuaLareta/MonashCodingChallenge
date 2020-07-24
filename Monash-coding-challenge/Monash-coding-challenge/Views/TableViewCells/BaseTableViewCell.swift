//
//  BaseTableViewCell.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var hasSetShadow:Bool = false
    // This will be our main "content view" to hold all elements
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        return containerView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Does not conform to NSCoding")
    }
    
    private func setupSelf() {
        self.selectionStyle = .none
        self.backgroundView = UIView()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        setupConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
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

}

extension BaseTableViewCell {
    
    /// A method that will add shadow to the cell. it uses the tableview and indexpath to determine what type of shadow effect will be used
    ///
    /// - Parameters:
    ///   - tableview : The instance of tableview that holds this cell
    ///   - indexPath : The indexPath that will represent this cell
    func addShadow(_ tableView: UITableView, indexPath: IndexPath)  {
        // Got the idea from  https://github.com/schluete/GroupedTableViewWithShadows
        // Separating the shadow for the top, mid, bottom cells
        let firstRow = indexPath.row == 0
        let lastRow = (indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1)
      
        // This uses the content view's bounds and add a 5 to left and right edgeInset and a -5 to top and bottom
        var shadowRect = self.contentView.bounds.insetBy(dx: 5, dy: -5)
        // some adjustments with the width and origin to adjust the placement of the shadow
        shadowRect.size.width -= 10
        shadowRect.origin.x += 5
        
        // for first row we offset it by 10 so shadow won't be on top. If its a single row we adjust it by 5 both origin and height
        if firstRow && lastRow {
            shadowRect.origin.y += 5
            shadowRect.size.height -= 5
        } else if firstRow {
            shadowRect.origin.y += 10
        } else if lastRow {
            // we remove the bottom shadow for the last row (not fully showing it, only the excess radius)
            shadowRect.size.height -= 2
        }
              
        
        // This masks the unwanted shadow by adjusting the frame and covering it up
        var mask = self.contentView.bounds.insetBy(dx: -10, dy: 0)
        
         if firstRow && lastRow {
            mask.size.height += 10
        } else if firstRow {
            // for the first row we start a bit higher and longer to not have a bleeding shadow
            mask.origin.y -= 10
            mask.size.height += 10
        } else if lastRow {
            // since we don't want to have too much excess at the bottom we just add 10 for now.
            mask.size.height += 10
        }
        
        // We use the convenience method for adding in a shadow to the view.
        self.contentView.addShadow(offset: .zero,
                       radius: 4,
                       color: .lightGray,
                       shadowPath: UIBezierPath(roundedRect: shadowRect, cornerRadius: 0).cgPath)
        
        // Since we have the frame from the mask we need to convert it to a shape layer and add it to the layer's mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: mask).cgPath
        // assign it to the view's layer mask
        self.contentView.layer.mask = maskLayer
    }
}
