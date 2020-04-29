//
//  StudentLocation.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 27/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

struct StudentLocation {
    let objectID: String
    let uniqueKey: String?
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    let updatedAt: Date
    let ACL: acl_t
    
}
