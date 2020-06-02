//
//  OnTheMapClient.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 1/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation
import CoreLocation

class OnTheMapClient {
    
    struct Auth {
        
        static var sessionID = ""
        static var uniqueKey = ""
        static var firstName = ""
        static var lastName = ""
        static var mapString = ""
        static var mediaURL = ""
        static var objectId = ""
        static var longitude: Double = 0
        static var latitude: Double = 0
        static var createdAt = ""
        static var updatedAt = ""
        
    }
    
    
    enum Endpoints {
        
        case PostUdacity
        case GetStudentLocation
        case PostStudentLocation
        case GetUniqueStudentLocation
        case GetPublicUserData
        
        
        var StringValue: String {
            switch self {
            
            case .PostUdacity: return "https://onthemap-api.udacity.com/v1/session"
            case .GetStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
            case .PostStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .GetUniqueStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey="
            case .GetPublicUserData: return "https://onthemap-api.udacity.com/v1/users/\(Auth.uniqueKey)"
            
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
    
    class func taskForUdacityGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
          
          let task = URLSession.shared.dataTask(with: url) { data, response, error in
              
            if error != nil { // Handle error...
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
                Auth.uniqueKey = response!.account.key!
                print(Auth.uniqueKey)
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func logout <ResponseType: Decodable>(responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            
        
            let decoder = JSONDecoder()
               do {
                let responseObject = try decoder.decode(Session.self, from: newData!)
                   DispatchQueue.main.async {
                    completion((responseObject as! ResponseType), nil)
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
    
    
    class func getStudentLocation(completion: @escaping ([StudentDetails], Error?) -> Void) {
        
        let URL = Endpoints.GetStudentLocation.url
        
        taskForGETRequest(url: URL, responseType: StudentInformation.self) {
            response, error in
            if let response = response {
                completion(response.studentInfo, nil)
                print(response)
                
            } else {
                completion([], error)
                
            }
        }
    }

    
    class func getUniqueStudentNames(completion: @escaping ([StudentDetails], Error?) -> Void) {
        
         let URL = Endpoints.GetUniqueStudentLocation.url
        
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
    
    class func getPublicUserData(completion: @escaping (UdacityPublicUserData?, Error?) -> Void) {
        
         let URL = Endpoints.GetPublicUserData.url
        
        taskForUdacityGETRequest(url: URL, responseType: UdacityPublicUserData.self) { (response, error) in
            
            if let response = response {
                Auth.firstName = response.firstName!
                Auth.lastName = response.lastName!
                completion(response, nil)
                print(response)
            } else {
                completion(nil, error)
                print(error!)
            }
            
        }
        
    
    }
    
    class func postStudentLocation (completion: @escaping (NewStudentLocationCreated?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Auth.uniqueKey)\", \"firstName\": \"\(Auth.firstName)\", \"lastName\": \"\(Auth.lastName)\",\"mapString\": \"\(Auth.mapString)\", \"mediaURL\": \"\(Auth.mediaURL)\",\"latitude\": \(Auth.latitude), \"longitude\": \(Auth.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
        
          print(String(data: data!, encoding: .utf8)!)
            
        let decoder = JSONDecoder()
                        do {
                            let responseObject = try decoder.decode(NewStudentLocationCreated.self, from: data!)
                              DispatchQueue.main.async {
                                  completion(responseObject, nil)
                                Auth.objectId = responseObject.objectId!
                                Auth.createdAt = responseObject.createdAt!
                                
                              }
                          } catch {
                           print(error)
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
    
    
    class func putStudentLocation (completion: @escaping (StudentLocationUpdated?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation/\(Auth.objectId)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Auth.uniqueKey)\", \"firstName\": \"\(Auth.firstName)\", \"lastName\": \"\(Auth.lastName)\",\"mapString\": \"\(Auth.mapString)\", \"mediaURL\": \"\(Auth.mediaURL)\",\"latitude\": \(Auth.latitude), \"longitude\": \(Auth.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
        
          print(String(data: data!, encoding: .utf8)!)
            
        let decoder = JSONDecoder()
                        do {
                            let responseObject = try decoder.decode(StudentLocationUpdated.self, from: data!)
                              DispatchQueue.main.async {
                                  completion(responseObject, nil)
                                Auth.updatedAt = responseObject.updatedAt!
                               
                              }
                          } catch {
                           print(error)
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
    
    class func processgeoCodeResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to find appropriate Geocode Address (\(error))")
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
            // write code to post latitude, longitude, mediaURL to logged-in user data
                Auth.longitude = location.coordinate.longitude
                Auth.latitude = location.coordinate.latitude
                
            } else {
                print("No matching location found")
            }
        }
    }
    
    
    class func passMediaURL(mediaURL: String?) {
        if mediaURL != nil {
            Auth.mediaURL = mediaURL!
        } else {
            print("No Media URL entered")
        }
        
    }
    
}
    

