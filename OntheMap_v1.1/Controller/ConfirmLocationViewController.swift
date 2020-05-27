//
//  LocationViewController.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 20/5/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var location: CLLocation?
    
    let manager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest //uses lots of battery
        manager.startUpdatingLocation()
    
        
        print(location!)
        print("testing MapViewDidAppear")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = location {
            manager.stopUpdatingLocation()
            
            render(location)
            
            print(location)
            print("testing LocationManager")
            
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
        print("testing render func")
        
        
    }

}
    

