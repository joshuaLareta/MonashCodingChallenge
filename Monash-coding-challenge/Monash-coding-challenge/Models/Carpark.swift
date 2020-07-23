//
//  Carpark.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

struct Carpark: Codable {
    let location: String?
    let total: Int
    let available: Int
}

extension Carpark {
    func carSpaceHealthCheck() -> Int {
        let max: Int = 10
        // lets get a percentage of the remaning car spot
        var remaining = Int(floor(((Float(available)/Float(total)) * Float(max))))
        if remaining == 0 && available >= 0 {
            remaining = 1 // have atleast 1 to signify there is still a spot
        }
        return remaining
    }
}
