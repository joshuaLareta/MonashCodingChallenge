//
//  CarParkDataProvider.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

protocol CarParkDataProviderProtocol: DataProviderProtocol  {
    typealias ResponseData = [Carpark]
}

extension CarParkDataProviderProtocol {
    var data: String? {
        return """
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
                         "available":9
                        },
                        {
                         "location":"Building D ",
                         "total":8,
                         "available":2
                        }
                      ]
        }
        """
    }
}

class CarParkDataProvider: CarParkDataProviderProtocol {
    func requestData(_ completion: DataProviderCallback? = nil) {
        guard let data = data?.data(using: .utf8) else {
            completion?(nil, DataProcessingError.error(withErrorCode: .cannotProcess) )
            return
        }
        do {
            let decodedData = try JSONDecoder().decode([String: [Carpark]].self, from: data)
            let carParks = Array(decodedData.values).first
            completion?(carParks, nil)
        } catch {
            completion?(nil, error)
        }
    }
}
