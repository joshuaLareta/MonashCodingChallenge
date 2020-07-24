//
//  Transport.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

struct Transport: Codable {
    var from: String?
    var to: String?
    var travelTime: TimeInterval
}


extension Transport {
    func travelTimeDisplay() -> String? {
        let time = Int(travelTime)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        var display: String = ""
        if hours > 0 {
            display += String(format: "%d %@", hours, hours > 1 ? NSLocalizedString("hours", comment: "plural"): NSLocalizedString("hour", comment: "singular"))
        }
        
        if minutes > 0 {
            if display.isEmpty == false {
                display += " "
            }
            display += String(format: "%d %@", minutes, minutes > 1 ? NSLocalizedString("mins", comment: "plural"): NSLocalizedString("min", comment: "singular"))
        }
        return display
    }
}
