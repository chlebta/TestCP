//
//  MapView.swift
//  TestCP
//
//  Created by Ahmed K on 06/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import UIKit
import Mapbox
import Cartography

class MapView: UIView {
    
    fileprivate let userAnnoationIdentifier = "userLocationViewIdentifier"
    fileprivate let destinationAnnoationIdentifier = "destinationLocationViewIdentifier"

    
    var mapView:MGLMapView!
    var destinationPin: MGLPointAnnotation = MGLPointAnnotation()
    var fakeDestinationPin: UIImageView = UIImageView()
    
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
    func updateDestinationPin( _ place: Place) {
        guard let lat = place.latitude,
            let long = place.longitude else {
                return
        }
        
        //Update the destination Pin
        destinationPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
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
        
        
        destinationPin.coordinate = mapView.centerCoordinate
        destinationPin.title = "Destination"
        destinationPin.subtitle = "Current Location"
        mapView.addAnnotation(destinationPin)
        
        fakeDestinationPin.image = UIImage(named: "pin")
        fakeDestinationPin.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        fakeDestinationPin.contentMode = .center
        fakeDestinationPin.isHidden = true
        addSubview(fakeDestinationPin)

        
        constrain(mapView, fakeDestinationPin) { (parent, pin) in
            pin.center == parent.center
        }
        
        
    }
    
    //Customise current user location view
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        //custom annotation for the user location
        if annotation is MGLUserLocation  {
            //check if current user location view was already created
            var userLocationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: userAnnoationIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if userLocationAnnotationView == nil {
                userLocationAnnotationView = UserLocationView(reuseIdentifier: userAnnoationIdentifier)
                
            }
            return userLocationAnnotationView
        }
        
        //Custom annotation for the destination pin
        if annotation is MGLPointAnnotation  {
            var customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: destinationAnnoationIdentifier)
            
            if customAnnotationView == nil {
                customAnnotationView = UserLocationView(reuseIdentifier: destinationAnnoationIdentifier)
                
            }
            return customAnnotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        
        mapView.showsUserLocation = false
        fakeDestinationPin.isHidden = false
        //Remove the destination pin
        // => so when user drag he can't see it and he can see only one pin ( the fake pin)
        mapView.removeAnnotation(destinationPin)
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        //Add the destination pin
        // => So when user click on the fakePin he can see the details

        //Another way : Instead of using a fake and real pin, it's possible to make the imageView clickable or use a custom view

        destinationPin.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(destinationPin)
        
        destinationPin.subtitle = "Loading"
        reloadDestinationAddress(mapView.centerCoordinate)
    }
}

extension MapView {
    fileprivate func reloadDestinationAddress( _ coordinates: CLLocationCoordinate2D) {
        ApiManager.geoCodeThis(coordinates) { (result, error) in
            if let place = result?.first {
                self.destinationPin.subtitle = place.longName
            }
            else {
                self.destinationPin.subtitle = "Unknow"
            }
        }
    }
}


