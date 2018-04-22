//
//  PlaceModel.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import CoreLocation
import Foundation

public struct PlaceSearchResultModel {
    let nextPageToken: String
    let results: [PlaceModel]
}

public struct PlaceModel {
    let location: CLLocationCoordinate2D
    
    /// ['icon']
    let categoryIcon: String
    
    let id: String
    let name: String
    let placeID: String
    
    let rating: Double
    
    let reference: String
    
    let types: [String]
    
    let address: String
    
    let isOpen: Bool
    
    let photo: [PlacePhotoModel]
    
    let categories: [String]
}

struct PlacePhotoModel {
    let height: Int
    let width: Int
    
    let link: String
}

extension PlaceModel {
    static func DistanceSorter(me: CLLocationCoordinate2D) -> (PlaceModel, PlaceModel) -> Bool {
        return { $0.location.distance(to: me) < $1.location.distance(to: me) }
    }
    
    static func RatingSorter(_ lhs: PlaceModel, _ rhs: PlaceModel) -> Bool {
        return lhs.rating > rhs.rating
    }
}
