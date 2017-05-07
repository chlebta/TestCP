//
//  MapViewController.swift
//  TestCP
//
//  Created by Ahmed K on 06/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {

    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        view.addSubview(mapView)
    }


}
