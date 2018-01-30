//
//  SoundMapController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 7/7/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import GoogleMaps

class SoundMapController: UIViewController {

    var soundMarker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        if let soundMarker = soundMarker {
            soundMarker.map = mapView
            camera = GMSCameraPosition.camera(withTarget: soundMarker.position,
                                              zoom: 12.0)
            mapView.camera = camera
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
