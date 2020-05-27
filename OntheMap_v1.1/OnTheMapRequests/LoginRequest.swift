//
//  LoginRequest.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 12/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    
    let loginInfo: Udacity
    
    enum CodingKeys: String, CodingKey {
        case loginInfo = "udacity"
    }
    
}

struct Udacity: Codable {
    
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
    case username
    case password
    
}
    
}
