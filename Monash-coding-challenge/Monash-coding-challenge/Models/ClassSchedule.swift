//
//  ClassSchedule.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

struct ClassSchedule: Codable {
    let start: Date?
    let end: Date?
    let subject: String?
    let educator: String?
    let location: String?
}

extension ClassSchedule {
    private func formatToDisplayTime(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}

extension ClassSchedule {
    
    func startDate() -> String? {
        return formatToDisplayTime(start)?.uppercased()
    }
    
    func endDate() -> String? {
        return formatToDisplayTime(end)?.uppercased()
    }
    
    func detailDisplay() -> String? {
        var displayString = ""
        if let educatorName = educator {
            displayString += educatorName
        }
        // If there is already a text string we append to the next line.
        if displayString.isEmpty == false {
            displayString.append("\n")
        }
        
        if let locationString = location {
            displayString += locationString
        }
        return displayString
    }
}
