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
    @IBOutlet weak var btnZoomIn: UIButton!
    @IBOutlet weak var btnZoomOut: UIButton!
    @IBOutlet weak var btnFindMyWay: UIButton!
    var locationManager = CLLocationManager()
    var aLat: CLLocationDegrees??
    var aLon: CLLocationDegrees??
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        //Permission and finding inital location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        
        mapView.showsUserLocation = true
        
        //Gesture to add marker
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
  }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            location = locations.first!
         let coordinateRegion = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters:1000)
            mapView.setRegion(coordinateRegion, animated: true)
            locationManager.stopUpdatingLocation()
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
            aLat = annotation.coordinate.latitude
            aLon = annotation.coordinate.longitude
            annotation.title = "Destination"
            annotation.subtitle = "Destination"
            self.mapView.addAnnotation(annotation)
        }
    
    @IBAction func findMyWay(_ sender: Any) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: aLat as! CLLocationDegrees, longitude: aLon as! CLLocationDegrees), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    //Zoom in feature
        @IBAction func zoomIn(_ sender: Any)
        {
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta /= 2.0
            region.span.longitudeDelta /= 2.0
            mapView.setRegion(region, animated: true)
        }
    
    //Zoom out feature
        @IBAction func zoomOut(_ sender: Any)
        {
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
            mapView.setRegion(region, animated: true)
        }
    
    
}

