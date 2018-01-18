//
//  CLService.swift
//  Remind
//
//  Created by pranav on 18/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import CoreLocation

class CLService: NSObject {
    private override init() {}
    static let shared = CLService()
    let locationManager = CLLocationManager()
    var shouldSetRegion = true
    
    func authorize() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func updatedLocation() {
        shouldSetRegion = true
        locationManager.startUpdatingLocation()
    }
}

extension CLService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location" )
        guard let currentLocation = locations.first else { return }
        if shouldSetRegion {
            shouldSetRegion = false
            //radius is in meters
            let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "startPosition")
            manager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER REGION VIA CL")
        NotificationCenter.default.post(name: NSNotification.Name("InternalNotification.enteredRegion"),
                                        object: nil)
    }
}
