//
//  OnTheMapClient.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 1/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    enum Endpoints {
        
        case PostUdacity
        case GetStudentLocation
        case PostStudentLocation
        
        
        var StringValue: String {
            switch self {
            
            case .PostUdacity: return "https://onthemap-api.udacity.com/v1/session"
            case .GetStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
            case .PostStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            
            }
        }
        
        var url: URL {
            return URL(string: StringValue)!
        }
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    print(responseObject)
                }
            } catch {
                print(error)
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data) as Error
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
        
        return task
    }
    

    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) ->Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = try! JSONEncoder().encode(body)
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
                    let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                       DispatchQueue.main.async {
                           completion(responseObject, nil)
                       }
                   } catch {
                    print(error)
                       do {
                        let errorResponse = try decoder.decode(UdacityResponse.self, from: newData!) as Error
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
        
        let URL = Endpoints.PostUdacity.url
        let credentials = Udacity(username: username, password: password)
        let loginbody = LoginRequest(loginInfo: credentials)
    
        taskForPOSTRequest(url: URL, responseType: SessionResponse.self, body: loginbody) { response, error in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
}
    
    class func getStudentLocation(completion: @escaping ([StudentDetails], Error?) -> Void) {
        
        let URL = Endpoints.GetStudentLocation.url
        
        taskForGETRequest(url: URL, responseType: StudentInformation.self) {
            response, error in
            if let response = response {
                completion(response.studentInfo, nil)
                print(response)
            } else {
                completion([], error)
                print(error!)
            }
        }
    }

    
    class func getUniqueStudentNames(Session: SessionResponse, completion: @escaping ([StudentDetails], Error?) -> Void) {
        
        let loggedinuser = Session.account
        
        let uniqueKey: String = loggedinuser.key
        
        let studentlocationURL: String = "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey="
        
        let url = URL(string: studentlocationURL + uniqueKey)!
        
        taskForGETRequest(url: url, responseType: StudentInformation.self) {
            response, error in
            if let response = response {
                completion(response.studentInfo, nil)
                print(response)
            } else {
                completion([], error)
                print(error!)
            }
        }
    }
    
    class func postStudentLocation (student: StudentDetails, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let URL = Endpoints.PostStudentLocation.url
        let newStudentInfo: String = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        
        taskForPOSTRequest(url: URL, responseType: NewStudentLocationCreated.self, body: newStudentInfo) {
            response, error in
                if error == nil {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
    }
    
}
    

