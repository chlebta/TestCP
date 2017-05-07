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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: MapBox
extension MapView: MGLMapViewDelegate {
    
    fileprivate func initMap() {
        let mapView = MGLMapView(frame: self.frame)
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
}

