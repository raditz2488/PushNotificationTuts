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
    var monitoredRegion: CLRegion? = nil
    
    func authorize() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func updatedLocation() {
        if let monitoredRegion = monitoredRegion {
            locationManager.stopMonitoring(for: monitoredRegion)
        }
        monitoredRegion = nil
        locationManager.requestLocation()
    }
}

extension CLService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location" )
        guard let currentLocation = locations.first else { return }
        if monitoredRegion == nil {
            //radius is in meters
            let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "startPosition")
            manager.startMonitoring(for: region)
            monitoredRegion = region
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER REGION VIA CL")
        if monitoredRegion == region {
            NotificationCenter.default.post(name: NSNotification.Name("InternalNotification.enteredRegion"),
                                            object: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager.Error:", error)
    }
}
