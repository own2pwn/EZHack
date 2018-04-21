//
//  PlaceProvider.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Alamofire
import CoreLocation
import Promise
import SwiftyJSON
import UIKit

public enum PlaceRankType: String {
    case prominence
}

public typealias PlaceListPromise = Promise<[PlaceModel]>

public final class PlaceProvider {

    // MARK: - Members
    
    public static let shared = PlaceProvider()
    
    private static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    private static let apiKEY = "AIzaSyAhE7VMP3oybjetIhBqEk-WLJCN-5HYacE"
    
    // MARK: - Interface
    
    public func get(by location: CLLocationCoordinate2D, radius: Double = 300, rank: PlaceRankType = .prominence) -> PlaceListPromise {
        let query = params(for: location, radius: radius, rank: rank)
        let placeList = PlaceListPromise()
        
        Alamofire.request(PlaceProvider.baseURL, method: .get,
                          parameters: query,
                          encoding: URLEncoding(destination: .queryString),
                          headers: nil)
            .responseJSON { placeList.fulfill(self.parsePlaceList($0)) }
        
        return placeList
    }
    
    private func params(for location: CLLocationCoordinate2D, radius: Double, rank: PlaceRankType) -> [String: String] {
        return ["key": PlaceProvider.apiKEY,
                "location": "\(location.latitude),\(location.longitude)",
                "radius": "\(radius)",
                "rankby": rank.rawValue,
                "sensor": "true"]
    }
    
    private func parsePlaceList(_ response: DataResponse<Any>) -> [PlaceModel] {
        var modelList = [PlaceModel]()
        
        guard let data = response.data else {
            log.warning("no data in response")
            return modelList
        }
        
        guard let json = try? JSON(data: data) else {
            log.warning("Can't init JSON!")
            return modelList
        }
        
        let results = json["results"].arrayValue
        for place in results {
            let geom = place["geometry"].dictionary!
            let locationObject = geom["location"]!.dictionary!
            let lat = locationObject["lat"]!.double!
            let lon = locationObject["lng"]!.double!
            
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let categoryIcon = place["icon"].string!
            let id = place["id"].string!
            let name = place["name"].string!
            let placeID = place["place_id"].string!
            let rating = place["rating"].doubleValue
            let reference = place["reference"].string!
            let address = place["vicinity"].string!
            
            let types = place["types"].arrayObject as! [String]
            
            let newModel = PlaceModel(location: location, categoryIcon: categoryIcon, id: id, name: name, placeID: placeID, rating: rating, reference: reference, types: types, address: address)
            
            modelList.append(newModel)
        }
        
        return modelList
    }
}
