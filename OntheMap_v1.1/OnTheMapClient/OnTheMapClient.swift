//
//  OnTheMapClient.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 1/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

class OnTheMapClient {

    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(username: String, password: String, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) ->Void) {
        
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            DispatchQueue.main.async {
                completion(nil, error)
            }
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
                   do {
                    let responseObject = try decoder.decode(ResponseType.self, from: data!)
                       DispatchQueue.main.async {
                           completion(responseObject, nil)
                       }
                   } catch {
                       do {
                        let errorResponse = try decoder.decode(UdacityResponse.self, from: data!) as Error
                           DispatchQueue.main.async {
                               completion(nil, errorResponse)
                           }
                       } catch {
                           DispatchQueue.main.async {
                               completion(nil, error)
                          }
                    }
                }
        }
        task.resume()
    }
    

class func login (username: String, password: String, _ completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
    
    let body = LoginRequest(username: username, password: password)
    taskForPOSTRequest(username: username, password: password, responseType: SessionResponse.self, body: body) { response, error in
        if error == nil {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }
}

}
    

