//
//  ViewController.swift
//  FindWay_Abhishek_C0769778
//
//  Created by user166476 on 6/10/20.
//  Copyright © 2020 user166476. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        //Permission and finding inital location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        
        //Zooming to user location
        if let userLocation = locationManager.location?.coordinate
        {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
        mapView.showsUserLocation = true
        
        //Gesture to add marker
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
  }
        @objc func longTap(sender: UIGestureRecognizer)
        {
        // Annotation at long press location
            if sender.state == .began
            {
                let locationInView = sender.location(in: mapView)
                let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
                addAnnotation(location: locationOnMap)
            }
        }

        func addAnnotation(location: CLLocationCoordinate2D)
        {
            //Removing previous annotations
            let oldAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(oldAnnotations)
            
            //Adding new annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Destination"
            annotation.subtitle = "Destination"
            self.mapView.addAnnotation(annotation)
        }
}

