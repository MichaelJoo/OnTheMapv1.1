//
//  UdacityResponse.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 12/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
}
    
extension UdacityResponse: LocalizedError {
        var errorDescription: String? {
            return statusMessage
        }
}

