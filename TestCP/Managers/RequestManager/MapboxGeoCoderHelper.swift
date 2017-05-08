//
//  MapboxGeoCoderHelper.swift
//  TestCP
//
//  Created by Ahmed K on 08/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import Foundation
import MapboxGeocoder

class MapboxGeoCoderHelper {
    
    static func geoCode( _ address: String, _ completionHanlder: geoCodeResult? = nil) {
        let geocoder = Geocoder.shared
        let options = ForwardGeocodeOptions(query: address)

        let _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            if let placemarks = placemarks {
                let parsedArray = placemarks.flatMap({ placemark -> Place? in
                    return Place(name: placemark.name, longName: placemark.qualifiedName, latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude)
                })
                completionHanlder?(parsedArray, nil)
            }
            else {
                completionHanlder?(nil, error)

            }
        }
    }
    
    static func geoCode( _ coordinates: CLLocationCoordinate2D, _ completionHanlder: geoCodeResult? = nil) {
        
        let geocoder = Geocoder.shared
        let options = ReverseGeocodeOptions(coordinate: coordinates)
        
        let task = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                completionHanlder?(nil, error)
                return
            }
            
            let place = Place(name: placemark.name, longName: placemark.qualifiedName, latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude)
            
            completionHanlder?([place], nil)
            
        }
    }
}
