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
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices


enum udacityURL: String {
    case https = "https://onthemap-api.udacity.com/v1/session"
    case http = "http://onthemap-api.udacity.com/v1/session"
    case error = "This is not a URL"
}

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, LoginButtonDelegate {
    

    @IBOutlet weak var loginProviderStackView: UIStackView!
    @IBOutlet weak var FBloginButton: UIButton!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // set-up OnTheMap custom login function
    @IBAction func loginTabbed(_ sender: UIButton) {
        
        let useremail = emailAddress.text!
        let userpassword = password.text!
        
            OnTheMapClient.login(username: useremail, password: userpassword) {
            (success, error) in DispatchQueue.main.async {
            if success {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBarController
            self.present(TabBarController, animated: true, completion: nil)
            
            OnTheMapClient.getPublicUserData (completion: { (PublicUserInfoDetails, error) in
                
            })

            } else {
                let alertVC = UIAlertController(title: "Login Failure", message: "Invalid Username and/or password", preferredStyle: .alert)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //set-up Apple login view
        setupProviderLoginView()
        
        //set-up Facebook Login, also to read email and password
        
        let FacebookloginButton = FBLoginButton()
        FacebookloginButton.delegate = self
        FacebookloginButton.permissions = ["public_profile", "email"]
        

        // Google Sign-in Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Google Sign-in Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    // Add logout function for Facebook login
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged Out Via Facebook account")
    }
    
    // Add loginfunction for Facebook login - to read email and password
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        print("FBloginbutton tabbed")
        
        if error != nil {
            print(error?.localizedDescription as Any)
            return
        }
        
        //let credential =FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
       // Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
        //}
        
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            fetchProfile()
            showLoginViewController()
            
            print("GraphRequest")
            
            GraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (GraphRequestConnection, result, Error) in
                
                if Error != nil {
                    print("failed to start graph request:", error!)
                    return
                }
                print("completed login")
                print(result!)
            }
            
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBarController
        self.present(TabBarController, animated: true, completion: nil)
        
        OnTheMapClient.getPublicUserData (completion: { (PublicUserInfoDetails, error) in
            
        })
        
        print(AccessToken.self)
          
    }
    
    // Add Loginbutton will login for Facebook login
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        print("buttonwilllogin")
        return true
    }
    
    // Add fetchprofile function for Facebook login
    func fetchProfile() {
        print("fetch profile")
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
      withError error: NSError!) {
        if (error == nil) {
          // Perform any operations on signed in user here.
          // ...
            
            
            
        } else {
          print("\(error.localizedDescription)")
        }
    }
    
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
    
    
    /// - Tag: add_appleid_button
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                // Create an account in your system.
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                // For the purpose of this demo app, store the `userIdentifier` in the keychain.
                self.saveUserInKeychain(userIdentifier)
            
            
            case let passwordCredential as ASPasswordCredential:
            
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                // For the purpose of this demo app, show the password credential as an alert.
                DispatchQueue.main.async {
                    self.showPasswordCredentialAlert(username: username, password: password)
                }
                
            default:
                break
            }
        }
        
    private func saveUserInKeychain(_ userIdentifier: String) {
            do {
                try KeychainItem(service: "Do-Hyung-Joo.OntheMap-v1-1", account: "userIdentifier").saveItem(userIdentifier)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
        }
        
    private func showPasswordCredentialAlert(username: String, password: String) {
            let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
            let alertController = UIAlertController(title: "Keychain Credential Received",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

extension UIViewController {
        func showLoginViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController {
                loginViewController.modalPresentationStyle = .formSheet
                loginViewController.isModalInPresentation = true
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
}


