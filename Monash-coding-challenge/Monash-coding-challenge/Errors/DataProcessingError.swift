//
//  DataProcessingError.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 23/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

enum DataProcessingErrorCodes {
    case cannotProcess
    var statusCode: Int {
        return -400
    }
    
    func display() -> String {
        return NSLocalizedString("Cannot process request.\n Please Try again.", comment: "the request cannot be processed")
    }
}

class DataProcessingError: Error {
    fileprivate static let domain = "com.josh.app.dataprocessingerror"
    static func error(withErrorCode errorCode: DataProcessingErrorCodes) -> Error {
        return NSError(domain: DataProcessingError.domain, code: errorCode.statusCode, userInfo: [NSLocalizedDescriptionKey: errorCode.display()])
    }
}
