//
//  Place.swift
//  TestCP
//
//  Created by Ahmed K on 08/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import Foundation

//Place structure
struct Place {
    var name: String?
    var longName: String?
    var latitude: Double?
    var longitude: Double?
    
    
}

extension Place: Equatable {}

func ==(lhs: Place, rhs: Place) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
