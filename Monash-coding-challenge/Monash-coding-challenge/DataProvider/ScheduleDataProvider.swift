//
//  ScheduleDataProvider.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

protocol ScheduleDataProviderProtocol  {
    typealias ScheduleRequestCompletion = (_ data: [ClassSchedule]?, _ error: Error?) -> Void
    func requestScheduleData(_ completion: ScheduleRequestCompletion?)
}

extension ScheduleDataProviderProtocol {
    var data: [String]? {
        let first = """
        {
           "schedules":[
                        {
                         "start":"2020-07-01T03:35:00Z",
                         "end":"2020-07-01T04:30:00Z",
                         "subject":"CS 101 - Algo",
                         "educator":"John John",
                         "location":"C building 3B "
                        },
                        {
                        "start":"2020-07-01T01:35:00Z",
                        "end":"2020-07-01T02:30:00Z",
                        "subject":"CS 103 - Game Dev",
                        "educator":"John three",
                        "location":"C building 3B "
                        },
                        {
                        "start":"2020-07-01T05:35:00Z",
                        "end":"2020-07-01T06:30:00Z",
                        "subject":"CS 102 - Number Theory",
                        "educator":"Jane M",
                        "location":"C building 2B"
                       },
                      ]
        }
        """
        
        let second = """
        {
           "schedules":[
                        {
                        "start":"2020-07-01T01:35:00Z",
                        "end":"2020-07-01T02:30:00Z",
                        "subject":"CS 103 - Game Dev",
                        "educator":"John three",
                        "location":"C building 3B "
                        },
                        {
                         "start":"2020-07-01T21:35:00Z",
                         "end":"2020-07-01T22:30:00Z",
                         "subject":"CS 101 - Algo",
                         "educator":"John John",
                         "location":"C building 3B "
                        }
                      ]
        }
        """
        let third = """
               {
                  "schedules":[
                               {
                                "start":"2020-07-01T21:35:00Z",
                                "end":"2020-07-01T22:30:00Z",
                                "subject":"CS 101 - Algo",
                                "educator":"John John",
                                "location":"C building 3B "
                               }
                             ]
               }
               """
        return [first, second, third]
    }
}

class ScheduleDataProvider: ScheduleDataProviderProtocol {
    func requestScheduleData(_ completion: ScheduleRequestCompletion? = nil) {
        let random = Int(arc4random() % 3)
        guard let list = data, list.count > random, let data = list[random].data(using: .utf8) else {
            completion?(nil, DataProcessingError.error(withErrorCode: .cannotProcess) )
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedData = try decoder.decode([String: [ClassSchedule]].self, from: data)
            let schedules = Array(decodedData.values).first
            completion?(schedules, nil)
        } catch {
            completion?(nil, error)
        }
    }
}
