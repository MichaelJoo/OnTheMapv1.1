//
//  LOGINRequest.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 1/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation
import UIKit

class LOGINRequest {

class func loginUdacity (username: String, password: String, _ completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
    
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    // encoding a JSON body from a string, can also use a Codable struct
    let json = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
    request.httpBody = json.data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      if error != nil { // Handle error…
        print ("Invalid Username or password is being used. please try with correct username or password")
          completion(false, error?.localizedDescription)
          return
        }
      let range = 5..<data!.count
      let newData = data?.subdata(in: range) /* subset response data! */
      print(String(data: newData!, encoding: .utf8)!)
      completion(true, nil)
    }
    task.resume()
}
    
}
