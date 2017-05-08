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
   
    
    @IBOutlet weak var searchTextField: SearchTextField!

    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        view.insertSubview(mapView, belowSubview: searchTextField)
    }


}
