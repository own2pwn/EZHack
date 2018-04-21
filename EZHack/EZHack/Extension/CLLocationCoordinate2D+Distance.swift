//
//  CLLocationCoordinate2D+Distance.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import CoreLocation

public extension CLLocationCoordinate2D {
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    public static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }

    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    public func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: latitude, longitude: longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)

        return from.distance(from: to)
    }
}
