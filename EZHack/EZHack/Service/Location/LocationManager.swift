//
//  LocationManager.swift
//  YandexTransportWidget
//
//  Created by Evgeniy on 09.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import CoreLocation

public final class LocationManager {

    // MARK: - Members
    
    public weak var listener: LocationUpdateListener?
    
    // MARK: - Interface
    
    public func getCurrentLocation() -> CLLocationPromise {
        let lastKnownLocation = CLLocationPromise(optional: manager.location)
        
        return lastKnownLocation
    }
    
    public func checkRights() {
        if !canProcess { print("Smth wrong with CLLocation!") }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    public func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    public func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: - Internal
    
    private let manager: CLLocationManager
    
    private var canProcess: Bool { return CLLocationManager.locationServicesEnabled() }
    
    // MARK: - Init
    
    public init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
}

/*
 extension LocationManager: CLLocationManagerDelegate {
 public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 
 }
 }
 */
