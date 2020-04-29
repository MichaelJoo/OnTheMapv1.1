//
//  Struct.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 1/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation
import CoreFoundation


// create a Codable struct called "POST" with the correct properties
struct Post: Codable {
    let username: String
    let password: String
}

// create an instance of the Post struct with your own values
let post = Post(username: "account@domain.com", password: "********")
