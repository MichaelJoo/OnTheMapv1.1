//
//  AddUserInfoViewController.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 20/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class AddUserInfoViewController: UIViewController, CLLocationManagerDelegate {
    
    var students = [StudentDetails]()
    var userDetail = [UdacityPublicUserData]()
    
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var userMediaURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        
        let address = userLocation.text!
        let mediaURL = userMediaURL.text!
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LocationViewController = storyBoard.instantiateViewController(withIdentifier: "LocationView") as! ConfirmLocationViewController
        self.present(LocationViewController, animated: true, completion: nil)
        
       geocoder.geocodeAddressString(address) {
        (placemarks, error) in
        
        OnTheMapClient.processgeoCodeResponse(withPlacemarks: placemarks,error: error)
        
        ConfirmLocationViewController.location = placemarks?.first?.location
        
        
        print(LocationViewController.location!)
        
        print(placemarks!)
        
        if error != nil {
            let alertVC = UIAlertController(title: "Invalid Input", message: "No Matching Location found or Invalid User inputs", preferredStyle: .alert)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            return
        }
            }
        }
    
}
