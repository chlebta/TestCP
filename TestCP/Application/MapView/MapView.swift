//
//  MapView.swift
//  TestCP
//
//  Created by Ahmed K on 06/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import UIKit
import Mapbox

class MapView: UIView {
    
    fileprivate let userAnnoationIdentifier = "userLocationViewIdentifier"
    
    var mapView:MGLMapView!
    var destinationPin: MGLPointAnnotation = MGLPointAnnotation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:
extension MapView {
    func addPin( _ place: Place) {
        guard let lat = place.latitude,
            let long = place.longitude else {
                return
        }
        
        destinationPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        destinationPin.title = "Destination"
        destinationPin.subtitle = place.longName

        mapView.addAnnotation(destinationPin)
        mapView.setCenter(destinationPin.coordinate, zoomLevel: 16, animated: true)
    }
}

//MARK: MapBox
extension MapView: MGLMapViewDelegate {
    
    fileprivate func initMap() {
        mapView = MGLMapView(frame: self.frame)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        addSubview(mapView)
        
    }
    
    //Customise current user location view
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        guard annotation is MGLUserLocation else {
            return nil
        }
        //check if current user location view was already created
        var userLocationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: userAnnoationIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if userLocationAnnotationView == nil {
            userLocationAnnotationView = UserLocationView(reuseIdentifier: userAnnoationIdentifier)

        }
        return userLocationAnnotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}


