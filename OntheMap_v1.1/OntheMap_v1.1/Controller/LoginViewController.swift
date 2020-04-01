//
//  LoginViewController.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 17/3/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation

enum udacityURL: String {
    case https = "https://onthemap-api.udacity.com/v1/session"
    case http = "http://onthemap-api.udacity.com/v1/session"
    case error = "This is not a URL"
}

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

    
    @IBAction func loginTabbed(_ sender: UIButton) {
        
        let useremail = emailAddress.text!
        let userpassword = password.text!
        
        LOGINRequest.loginUdacity(username: useremail, password: userpassword)
    }
    
    @IBAction func signUp(_ sender: Any) {
    }
    
}

