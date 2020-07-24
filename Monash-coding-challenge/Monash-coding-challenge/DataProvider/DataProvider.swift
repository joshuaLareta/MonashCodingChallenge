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
