//
//  SessionResponse.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 9/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    
    let account: Account
    let session: Session

}


struct Account: Codable {
    
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
    case registered = "registered"
    case key = "key"
    
}
    
}

struct Session: Codable {
    
    let sessionId: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
       case sessionId = "id"
       case expiration = "expiration"
}

}




