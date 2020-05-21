//
//  CurrentUserInfo.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 20/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

struct CurrentUserInfo: Codable {
    
    var locations = [StudentDetails]()
    var user: PublicUserInfoDetails?
    static var shared = CurrentUserInfo()
    
}


struct PublicUserInfoDetails: Codable {
    
    let user: [UdacityPublicUserData]
    
    enum CodingKeys: String, CodingKey {
          case user = "user"
    }
}


struct UdacityPublicUserData: Codable {
    
    let lastName: String
    let firstName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key = "key"
     }
}
