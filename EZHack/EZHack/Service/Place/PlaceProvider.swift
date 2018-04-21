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
    
    static let apiKEY = "AIzaSyAhE7VMP3oybjetIhBqEk-WLJCN-5HYacE"
    
    // MARK: - Interface
    
    public static func getImageLink(for ref: String, maxFrame: CGSize, result: @escaping (String) -> Void) {
        let maxWidth = Int(maxFrame.width)
        let maxHeight = Int(maxFrame.height)
        
        let str = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxWidth)&maxheight=\(maxHeight)&key=\(PlaceProvider.apiKEY)&photoreference=\(ref)"
        
        let url = URL(string: str)!
        
        Alamofire.request(url).responseString { r in
            let str = r.result.value
            log.debug(str)
        }.resume()
        
    }
    
    public func get(by location: CLLocationCoordinate2D, radius: Double = 300, rank: PlaceRankType = .prominence) -> PlaceListPromise {
        let query = params(for: location, radius: radius, rank: rank)
        let placeList = PlaceListPromise()
        
        Alamofire.request(PlaceProvider.baseURL, method: .get,
                          parameters: query,
                          encoding: URLEncoding(destination: .queryString),
                          headers: nil)
            .responseJSON {
                let data = $0.data!
                let firstPageResults = self.parsePlaceList(data)
                if firstPageResults.items.count >= 20 {
                    self.getNextPage(with: firstPageResults.token, result: {
                        let fullList = firstPageResults.items + $0
                        placeList.fulfill(fullList)
                    })
                } else {
                    placeList.fulfill(self.parsePlaceList(data).items)
                }
            }
        
        return placeList
    }
    
    private func getNextPage(with token: String, result: @escaping ([PlaceModel]) -> Void) {
        let str = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(PlaceProvider.apiKEY)&pagetoken=\(token)"
        let url = URL(string: str)!
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            guard let data = data else { return }
            let parsed = self.parsePlaceList(data)
            result(parsed.items)
            
        }).resume()
    }
    
    private func params(for location: CLLocationCoordinate2D, radius: Double, rank: PlaceRankType) -> [String: String] {
        return ["key": PlaceProvider.apiKEY,
                "location": "\(location.latitude),\(location.longitude)",
                "radius": "\(radius)",
                "rankby": rank.rawValue,
                "sensor": "true"]
    }
    
    private func parsePlaceList(_ response: Data) -> (token: String, items: [PlaceModel]) {
        var modelList = [PlaceModel]()
        
        let json = try! JSON(data: response)
        
        let results = json["results"].arrayValue
        let nextPageToken = json["next_page_token"].stringValue
        
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
            
            let isOpen = place["opening_hours"].dictionaryValue["open_now"]?.bool ?? false
            
            var photoModel = [PlacePhotoModel]()
            let photos = place["photos"].arrayValue
            for photo in photos {
                let h = photo["height"].intValue
                let w = photo["width"].intValue
                let link = photo["photo_reference"].stringValue
                
                let newModel = PlacePhotoModel(height: h, width: w, link: link)
                photoModel.append(newModel)
            }
            
            let categoryList = place["types"].arrayObject as? [String] ?? [String]()
            
            let newModel = PlaceModel(location: location, categoryIcon: categoryIcon, id: id, name: name, placeID: placeID, rating: rating, reference: reference, types: types, address: address, isOpen: isOpen, photo: photoModel, categories: categoryList)
            
            modelList.append(newModel)
        }
        
        return (nextPageToken, modelList)
    }
}
