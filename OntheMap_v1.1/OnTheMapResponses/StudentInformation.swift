//
//  StudentInformation.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 13/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation


struct StudentInformation: Codable {
    
    let studentInfo: [studentDetails]
    
    enum CodingKeys: String, CodingKey {
        case studentInfo = "results"
    }
}

//Adding Equatable protocol to array within StudentInfomation struct to enable sequence operations as below description.
//  Some sequence and collection operations can be used more simply when the elements conform to Equatable. For example, to check whether an array contains a particular value, you can pass the value itself to the contains(_:) method when the array’s element conforms to Equatable instead of providing a closure that determines equivalence. The following example shows how the contains(_:) method can be used with an array of strings

struct studentDetails: Codable, Sequence {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longitude = "longitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case updatedAt = "updatedAt"
        
    }
}
