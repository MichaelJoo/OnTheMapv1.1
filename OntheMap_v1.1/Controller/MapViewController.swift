//
//  MapViewController.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 28/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        //create "location" array that is an array of dictionary objects, which contain student location information downloaded from getStudent API. Upon a successful login and getStudentInformation API call, the location array should have been populated with student information data.
        
        let locationData = [studentDetails].self
        
        
        
        //create "location" array that is an array of dictionary objects, which contain student location information downloaded from getStudent API. Upon a successful login and getStudentInformation API call, the location array should have been populated with student information data.
                
                let locations = [studentDetails].self
                
                
                //creating so called "annotation" that are
                //"Summary of A concrete annotation object tied to the specified point on the map"
                //Purpose of creating annotation is - mentioned as "You use this class, rather than define a custom annotation object, in situations where all you want to do is display a title string at the specified point on the map."
                var annotations = [MKPointAnnotation]()
                
                
                //Method 1 - use for dictionary in operations to manipulate student information parmaeters to create CLLocationDegree values after manipulating the parameters for "annotation".
                
                
                for dictionary in locations {
                    
                    let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    
                }
                
                //Method 2 - another attempt to create manipulated parameters based on student information struct
                
                let coordinate = CLLocationCoordinate2D(latitude: studentDetails.latitude, longitude: studentDetails.longitude)
                
        }
        
}
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.canOpenURL(URL(string: toOpen)!)
            }
        }
    }
    
    

}
