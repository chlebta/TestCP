//
//  ApiManager.swift
//  TestCP
//
//  Created by Ahmed K on 08/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import Foundation
import CoreLocation

typealias geoCodeResult = (_ books: [Place]?, _ error: Error?) -> Void

class ApiManager {
    
    static func geoCodeThis( _ address: String,  withCompletion: geoCodeResult? = nil) {
        MapboxGeoCoderHelper.geoCode(address, withCompletion)
    }
    
    static func geoCodeThis( _ location: CLLocationCoordinate2D,  withCompletion: geoCodeResult? = nil) {
        MapboxGeoCoderHelper.geoCode(location, withCompletion)
    }
    
}
