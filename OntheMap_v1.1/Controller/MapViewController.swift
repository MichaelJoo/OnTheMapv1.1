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
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        OnTheMapClient.getStudentLocation(completion: { (StudentInformation, error) in
                            
                for studentInfo in StudentInformation {
                    
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(studentInfo.latitude), CLLocationDegrees(studentInfo.longitude))
                    
                    let name = studentInfo.firstName + studentInfo.lastName
                    
                    pointAnnotation.title = name
                    pointAnnotation.subtitle = studentInfo.mediaURL
                    self.mapView.addAnnotation(pointAnnotation)
                }
            })
        
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
        
}
    
   
