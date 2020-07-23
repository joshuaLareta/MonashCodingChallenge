//
//  TableSections.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

enum DataSection {
    case schedules(_ list: [ClassSchedule])
    case carparks(_ list: [Carpark])
    case transport(_ list: [String])
    
    var title: String? {
        switch self {
        case .carparks:
            return NSLocalizedString("Available car parks", comment: "Available car parks title")
        default:
            return nil
        }
    }
}

struct TableSections {
    let section: DataSection
    var itemCount: Int {
        switch section {
        case .schedules(let schedules):
            return schedules.count
        case .carparks(let carparks):
            return carparks.count
        case .transport(let transports):
            return transports.count
        }
    }
}
