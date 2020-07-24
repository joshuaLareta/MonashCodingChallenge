//
//  TransportDataProvider.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 24/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

protocol TransportDataProviderProtocol  {
    typealias TransportRequestCompletion = (_ data: [Transport]?, _ error: Error?) -> Void
    func requestTransportData(_ completion: TransportRequestCompletion?)
}

extension TransportDataProviderProtocol {
    var data: [String]? {
        let first = """
        {
           "Transport":[
                        {
                         "from":"Fawkner ",
                         "to":"Box hill",
                         "travelTime":3600
                        },
                        {
                         "from":"London",
                         "to":"Iceland",
                         "travelTime":5600
                        },
                        {
                         "from":"Geelong",
                         "to":"Mornington",
                         "travelTime":18000
                        }
                      ]
        }
        """
        let second = """
        {
           "Transport":[
                        {
                         "from":"Fawkner ",
                         "to":"Box hill",
                         "travelTime":3600
                        },
                        {
                         "from":"London",
                         "to":"Iceland",
                         "travelTime":5600
                        }
                      ]
        }
        """
        
        let third = """
        {
           "Transport":[
                        {
                         "from":"Fawkner ",
                         "to":"Box hill",
                         "travelTime":3600
                        }
                      ]
        }
        """
        return [first, second, third]
    }
}

class TransportDataProvider: TransportDataProviderProtocol {
    func requestTransportData(_ completion: TransportRequestCompletion? = nil) {
        let random = Int(arc4random() % 3)
        guard let list = data, list.count > random, let data = list[random].data(using: .utf8) else {
            completion?(nil, DataProcessingError.error(withErrorCode: .cannotProcess) )
            return
        }
        do {
            let decodedData = try JSONDecoder().decode([String: [Transport]].self, from: data)
            let transport = Array(decodedData.values).first
            completion?(transport, nil)
        } catch {
            completion?(nil, error)
        }
    }
}
