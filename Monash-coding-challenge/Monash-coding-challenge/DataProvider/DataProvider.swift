//
//  DataProvider.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

// Lets use protocol for a more generic response

protocol DataProviderProtocol {
    associatedtype ResponseData
    typealias DataProviderCallback = (_ data: ResponseData?, _ error: Error?) -> Void
    func requestData(_ completion: DataProviderCallback?)
}

// Expand the usage with other data provider
protocol UserDataProviderProtocol: DataProviderProtocol {
    typealias ResponseData = User
    var data: String? { get}
}

// Sample data request
extension UserDataProviderProtocol {
    var data: String? {
        return """
        {
           "User": {
                    "name":"John doe",
                    "semester_week":4
                 }
        }
        """
    }
}

protocol ScheduleDataProviderProtocol: DataProviderProtocol  {
    typealias ResponseData = [ClassSchedule]
}

extension ScheduleDataProviderProtocol {
    var data: String? {
        return """
        {
           "schedules":[
                        {
                         "start":"2020-07-01T21:35:00Z",
                         "end":"2020-07-01T22:30:00Z",
                         "subject":"CS 101 - Algo",
                         "educator":"John John",
                         "location":"C building 3B "
                        },
                        {
                         "start":"2020-07-01T23:35:00Z",
                         "end":"2020-07-01T24:30:00Z",
                         "subject":"CS 102 - Number Theory",
                         "educator":"Jane M",
                         "location":"C building 2B"
                        },
                        {
                        "start":"2020-07-01T01:35:00Z",
                        "end":"2020-07-01T02:30:00Z",
                        "subject":"CS 103 - Game Dev",
                        "educator":"John three",
                        "location":"C building 3B "
                        }
                      ]
        }
        """
    }
}

/// Provider for User info
class UserDataProvider: UserDataProviderProtocol {
    func requestData(_ completion: DataProviderCallback? = nil) {
        guard let data = data?.data(using: .utf8) else {
            completion?(nil, DataProcessingError.error(withErrorCode: .cannotProcess) )
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([String: User].self, from: data)
            let user = Array(decodedData.values).first
            completion?(user, nil)
        } catch {
            completion?(nil, error)
        }
    }
}


class ScheduleDataProvider: ScheduleDataProviderProtocol {
    func requestData(_ completion: DataProviderCallback? = nil) {
        guard let data = data?.data(using: .utf8) else {
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
