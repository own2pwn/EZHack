//
//  RouteController.swift
//  EZHack
//
//  Created by Evgeniy on 22.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import NMAKit
import UIKit

final class RouteController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var mapView: NMAMapView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMap()
    }
    
    // MARK: - Members
    
    private var router: NMACoreRouter!
    private var navigationManager: NMANavigationManager!
    private var currentRoute: NMARoute!
    
    // MARK: - Methods
    
    private func setupMap() {
        mapView.zoomLevel = 13.2
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: 55.794482, longitude: 37.515370), animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        
        mapView.positionIndicator.isVisible = true
        mapView.positionIndicator.isAccuracyIndicatorVisible = true
    }
    
    private func setupScreen() {
        setup()
    }
    
    private func setup() {
        let setup = [setColors]
        setup.forEach { $0() }
    }
    
    private func setColors() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func doRoute(_ sender: UIButton) {
        if router == nil {
            router = NMACoreRouter()
            navigationManager = NMANavigationManager.sharedInstance()
            
            navigationManager.delegate = self
            navigationManager.backgroundNavigationEnabled = true
        }
        
        let stops: NSMutableArray = NSMutableArray(capacity: 4)
        let hyderbad = NMAGeoCoordinates(latitude: 55.794482, longitude: 37.515370)
        let bangalore = NMAGeoCoordinates(latitude: 55.798392, longitude: 37.515087)
        
        stops.add(hyderbad)
        stops.add(bangalore)
        
        let routingMode = NMARoutingMode(routingType: .balanced, transportMode: .pedestrian, routingOptions: [])
        
        router.calculateRoute(withStops: stops as! [Any], routingMode: routingMode) { [mapView = mapView!] routeResult, _ in
            guard let result = routeResult, let routes = result.routes, !routes.isEmpty else { return }
            
            let route = routes[0]
            self.currentRoute = route
            
            guard let mapRoute = NMAMapRoute(route), let bounds = route.boundingBox else { return }
            mapView.add(mapObject: mapRoute)
            mapView.set(boundingBox: bounds, animation: .linear)
        }
    }
    
    private func startNavigation() {
        if navigationManager.navigationState == .idle {
            navigationManager.map = mapView
            
            let error = navigationManager.startTracking(.pedestrian)
            if error == nil {
                log.debug("fine")
            }
        }
        
        mapView.positionIndicator.accuracyIndicatorColor = .red
        
        // device btn
        // navigationManager.startTurnByTurnNavigation(currentRoute)
        
        // Set the map tracking properties
        navigationManager.mapTrackingEnabled = true
        navigationManager.mapTrackingAutoZoomEnabled = true
        navigationManager.mapTrackingOrientation = .dynamic
        navigationManager.isSpeedWarningEnabled = true
    }
}

extension RouteController: NMANavigationManagerDelegate {
    func navigationManager(_ navigationManager: NMANavigationManager, didUpdateManeuvers maneuver: NMAManeuver?, _ nextManeuver: NMAManeuver?) {
        log.debug(maneuver!)
        log.debug(nextManeuver!)
    }
    
    // Signifies that the system has found a GPS signal
    func navigationManagerDidFindPosition(_ navigationManager: NMANavigationManager) {
        log.debug("New position has been found")
    }
    
    func navigationManager(_ navigationManager: NMANavigationManager, didUpdateRealisticViewsForCurrentManeuver realisticViews: [String: NMAImage]) {
        log.debug("didUpdateRealisticViewsForCurrentManeuver")
    }
}
