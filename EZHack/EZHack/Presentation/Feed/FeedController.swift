//
//  ViewController.swift
//  EZHack
//
//  Created by supreme on 20/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import CoreLocation
import GooglePlaces
import UIKit

final class FeedController: UIViewController {

    // MARK: - Outlets
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    // MARK: - Members
    
    private let locator = LocationManager()
    
    private let provider = PlaceProvider.shared
    
    private var placesClient: GMSPlacesClient!
    
    // MARK: - Methods
    
    private func setupScreen() {
        setup()
        placesClient = GMSPlacesClient.shared()
    }
    
    private func setup() {
        let setup = [setColors, testMyLocation]
        setup.forEach { $0() }
    }
    
    private func setColors() {
    }
    
    private func testMyLocation() {
        locator.checkRights()
        locator.startUpdating()
        locator.stopUpdating()
        
        locator.getCurrentLocation()
            .then(printMyLocation)
    }
    
    private func printMyLocation(_ location: CLLocation) {
        // provider.get(by: location.coordinate)
        
        provider.get(by: location.coordinate).then { placeList in
            log.debug(placeList.count)
            
            for place in placeList {
                log.debug(place.name)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func retestLocation(_ sender: UIButton) {
        testMyLocation()
    }
}
