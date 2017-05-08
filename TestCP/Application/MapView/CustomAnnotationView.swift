//
//  CustomAnnotationView.swift
//  TestCP
//
//  Created by Ahmed K on 08/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import UIKit
import Mapbox

//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        layer.contentsScale = UIScreen.main.scale
        layer.contentsGravity = kCAGravityCenter
        layer.contents = UIImage(named: "pin")?.cgImage
        
    }
}
