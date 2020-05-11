//
//  SessionResponse.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 9/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    
    let success: Bool
    let accountData: AccountData
    let sessionData: SessionData
}


struct AccountData: Codable {
    
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
    case registered
    case key
    
}
    
}

struct SessionData: Codable {
    
    let sessionId: String
    let expiration: Date
    
    enum CodingKeys: String, CodingKey {
       case sessionId
       case expiration
}

}
