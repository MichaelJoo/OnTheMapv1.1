//
//  AddUserInfoViewController.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 20/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import UIKit
import Foundation

class AddUserInfoViewController: UIViewController {
    
    var currentSession = SessionResponse.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        OnTheMapClient.getUniqueStudentNames(Session: currentSession, completion: <#T##([studentDetails], Error?) -> Void#>)
     
        
        OnTheMapClient.getUniqueStudentNames(Session: SessionResponse) { ([studentDetails], Error?) in
            
        }
            
        }
        
    }


