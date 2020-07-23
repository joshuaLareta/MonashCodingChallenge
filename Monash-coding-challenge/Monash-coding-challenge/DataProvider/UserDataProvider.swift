//
//  UserDataProvider.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

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
