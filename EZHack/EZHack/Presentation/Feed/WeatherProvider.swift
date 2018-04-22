//
//  WeatherProvider.swift
//  EZHack
//
//  Created by supreme on 22/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Alamofire
import CoreLocation
import SwiftyJSON
import UIKit

struct WeatherModel {
    let temp: Double
    let iconURL: String
}

final class WeatherProvider {

    // MARK: - Methods
    
    func get(by coord: CLLocationCoordinate2D, result: @escaping (WeatherModel) -> Void) {
        let key = "721af8d5a479a787fcaabc4fb1f97c7b"
        
        let str = "https://api.openweathermap.org/data/2.5/find?lat=\(coord.latitude)&lon=\(coord.longitude)&cnt=1&APPID=\(key)"
        let url = URL(string: str)!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let json = try? JSON(data: data) else {
                log.warning("failed")
                return
            }
            
            guard let info = json["list"].arrayValue.first else { return }
            guard let tempInfo = info["main"].dictionary,
                let fTemp = tempInfo["temp"]?.double else { return }
            
            let cTemp = fTemp - 273.15
            
            guard let iconInfo = info["weather"].arrayValue.first,
                let iconPostfix = iconInfo["icon"].string else { return }
            
            let iconURL = "https://openweathermap.org/img/w/\(iconPostfix).png"
            
            let m = WeatherModel(temp: cTemp, iconURL: iconURL)
            result(m)
            
        }.resume()
    }
}
