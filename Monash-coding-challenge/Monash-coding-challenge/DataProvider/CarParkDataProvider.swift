//
//  CarParkDataProvider.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

protocol CarParkDataProviderProtocol {
    typealias CarParkRequestCompletion = (_ data: [Carpark]?, _ error: Error?) -> Void
    func requestCarParkData(_ completion: CarParkRequestCompletion?)
}

extension CarParkDataProviderProtocol {
    var data: [String]? {
        let first = """
        {
           "Carparks":[
                        {
                         "location":"Building B ",
                         "total":200,
                         "available":1
                        },
                        {
                         "location":"Building C",
                         "total":18,
                         "available":18
                        },
                        {
                         "location":"Building D ",
                         "total":8,
                         "available":3
                        }
                      ]
        }
        """
        let second = """
        {
           "Carparks":[
                        {
                         "location":"Building B Live Feed",
                         "total":200,
                         "available":200
                        },
                        {
                         "location":"Building D Broadcast",
                         "total":8,
                         "available":2
                        }
                      ]
        }
        """
        let third = """
        {
           "Carparks":[
                       {
                         "location":"Building D ",
                         "total":8,
                         "available":2
                        }
                      ]
        }
        """
        return [first, second, third]
    }
}

class CarParkDataProvider: CarParkDataProviderProtocol {
    func requestCarParkData(_ completion: CarParkRequestCompletion? = nil) {
        let random = Int(arc4random() % 3)
        guard let list = data, list.count > random, let data = list[random].data(using: .utf8) else {
            completion?(nil, DataProcessingError.error(withErrorCode: .cannotProcess) )
            return
        }
        do {
            let decodedData = try JSONDecoder().decode([String: [Carpark]].self, from: data)
            let data = Array(decodedData.values).first
            completion?(data, nil)
        } catch {
            completion?(nil, error)
        }
    }
}
