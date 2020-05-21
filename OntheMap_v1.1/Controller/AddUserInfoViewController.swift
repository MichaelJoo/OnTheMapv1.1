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
    
    var currentSession = SessionResponse(account: Account(registered: true, key: ""), session: Session(sessionId: "", expiration: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        OnTheMapClient.getUniqueStudentNames(Session: currentSession) { (studentDetails, error) in
            
        }
     
    }
    
    }


