//
//  ViewController.swift
//  EZHack
//
//  Created by supreme on 20/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import CoreLocation
import GooglePlaces
import Kingfisher
import NMAKit
import UIKit

final class FeedController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var placeTableView: UITableView!
    
    @IBOutlet var weatherImageView: UIImageView!
    
    @IBOutlet var weatherLabel: UILabel!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard locator.lastKnownLocation != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.reloadWeather()
            })
            return
        }
        reloadWeather()
    }
    
    private func reloadWeather() {
        guard let c = locator.lastKnownLocation else { return }
        let p = WeatherProvider()
        
        p.get(by: c) { m in
            DispatchQueue.main.async {
                self.updateWeather(with: m)
            }
        }
    }
    
    private func updateWeather(with m: WeatherModel) {
        let intVal = Int(m.temp)
        weatherLabel.text = "\(intVal) ºC"
        weatherImageView.kf.setImage(with: URL(string: m.iconURL))
    }
    
    // MARK: - Members
    
    private let locator = LocationManager()
    
    private let provider = PlaceProvider.shared
    
    private var placesClient: GMSPlacesClient!
    
    private var fullList: [PlaceModel] = []
    
    private var datasource: [PlaceModel] = []
    
    // private var mapView: NMAMapView!
    
    //
    
    @IBOutlet var mapView: NMAMapView!
    
    @IBOutlet var mapHeight: NSLayoutConstraint!
    
    private let maxTopContainerHeight = UIScreen.main.bounds.height * 0.5
    
    private let minTopViewHeight: CGFloat = 0
    
    private lazy var initialContentOffsetY: CGFloat = { maxTopContainerHeight - minTopViewHeight }()
    
    private let screenSize: CGSize = UIScreen.main.bounds.size
    
    // MARK: - Routing
    
    private var router: NMACoreRouter!
    private var navigationManager: NMANavigationManager!
    private var currentRoute: NMARoute!
    private var currentMapRoute: NMAMapRoute!
    
    // MARK: - Methods
    
    private func setupScreen() {
        setup()
        placesClient = GMSPlacesClient.shared()
        
        placeTableView.contentInset = UIEdgeInsets(top: initialContentOffsetY, left: 0, bottom: 0, right: 0)
        placeTableView.scrollIndicatorInsets = UIEdgeInsets(top: initialContentOffsetY, left: 0, bottom: 0, right: 0)
        placeTableView.setContentOffset(CGPoint(x: 0, y: -maxTopContainerHeight), animated: false)
        
        setupRouting()
    }
    
    private func updateTableViewHeight(newOffset: CGFloat) {
        mapHeight.constant = (maxTopContainerHeight - newOffset).bounded(min: minTopViewHeight, max: maxTopContainerHeight)
    }
    
    private func setupRouting() {
        mapView.zoomLevel = 13.2
        
        if let myLocation = locator.lastKnownLocation {
            mapView.set(geoCenter: NMAGeoCoordinates(latitude: myLocation.latitude, longitude: myLocation.longitude), animation: .linear)
        }
        mapView.copyrightLogoPosition = .bottomCenter
        
        mapView.positionIndicator.isVisible = true
        mapView.positionIndicator.isAccuracyIndicatorVisible = true
    }
    
    private func buildRoute(to point: CLLocationCoordinate2D) {
        if router == nil {
            router = NMACoreRouter()
            navigationManager = NMANavigationManager.sharedInstance()
            
            // navigationManager.delegate = self
            // navigationManager.backgroundNavigationEnabled = true
        }
        
//        let stops: NSMutableArray = NSMutableArray(capacity: 4)
//        let hyderbad = NMAGeoCoordinates(latitude: 55.794482, longitude: 37.515370)
//        let bangalore = NMAGeoCoordinates(latitude: 55.798392, longitude: 37.515087)
        
        let me = locator.lastKnownLocation!
        let start = NMAGeoCoordinates(latitude: me.latitude, longitude: me.longitude)
        let stop = NMAGeoCoordinates(latitude: point.latitude, longitude: point.longitude)
        let stops = [start, stop]
        
        let routingMode = NMARoutingMode(routingType: .balanced, transportMode: .pedestrian, routingOptions: [])
        
        router.calculateRoute(withStops: stops, routingMode: routingMode) { [mapView = mapView!] routeResult, _ in
            guard let result = routeResult, let routes = result.routes, !routes.isEmpty else { return }
            
            let route = routes[0]
            self.currentRoute = route
            
            guard let mapRoute = NMAMapRoute(route), let bounds = route.boundingBox else { return }
            mapView.add(mapObject: mapRoute)
            mapView.set(boundingBox: bounds, animation: .linear)
            
            self.currentMapRoute = mapRoute
            
            self.startNavigation()
        }
    }
    
    private func startNavigation() {
        if navigationManager.navigationState == .idle {
            navigationManager.map = mapView
            
            let error = navigationManager.startTracking(.pedestrian)
        }
        
        navigationManager.mapTrackingEnabled = true
        // navigationManager.mapTrackingAutoZoomEnabled = true
        navigationManager.mapTrackingOrientation = .dynamic
        navigationManager.isSpeedWarningEnabled = true
    }
    
    private func setup() {
        let setup = [testMyLocation]
        setup.forEach { $0() }
    }
    
    private func testMyLocation() {
        locator.checkRights()
        locator.startUpdating()
        locator.stopUpdating()
        
        locator.getCurrentLocation()
            .then(getNearbyPlaces)
    }
    
    private func getNearbyPlaces(_ location: CLLocation) {
        provider.get(by: location.coordinate).then(updateView)
    }
    
    private func updateView(with placeList: [PlaceModel]) {
        let me = locator.lastKnownLocation!
        fullList = placeList
            .sorted(by: PlaceModel.DistanceSorter(me: me))
            .filter { $0.photo.first?.link != nil }
        
        datasource = fullList
        placeTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func openSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SettingsController {
            dest.interactionDelegate = self
        }
    }
}

extension FeedController: SettingsInteractionDelegate {
    func update(with model: SortModel) {
        datasource = fullList
        
        if !model.shouldConsiderClosed {
            datasource = fullList.filter { $0.isOpen }
        }
        
        guard let me = locator.lastKnownLocation else { return }
        
        switch model.sortType {
        case .distance:
            datasource = datasource.sorted(by: PlaceModel.DistanceSorter(me: me))
        case .rating:
            datasource = datasource.sorted(by: PlaceModel.RatingSorter)
        }
        
        placeTableView.reloadData()
    }
    
    @objc
    private func onPan(_ sender: UIPanGestureRecognizer) {
        log.debug(sender)
    }
}

extension FeedController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        updateTableViewHeight(newOffset: y + initialContentOffsetY)
    }
}

extension FeedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceCell = tableView.dequeueReusableCell(at: indexPath)
        
        let item = datasource[indexPath.row]
        let model = buildModel(using: item)
        cell.model = model
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func buildModel(using item: PlaceModel) -> PlaceDisplayModel {
        let cat = item.categories.first == "point_of_interest" ? "достопримечательность" : item.categories[0]
        
        let me = locator.lastKnownLocation!
        let dist = CLLocationCoordinate2D.distance(from: item.location, to: me)
        
        let status = item.isOpen ? PlaceStatusType.open : .closed
        let link = item.photo.first?.link ?? item.categoryIcon
        
        let model = PlaceDisplayModel(imageLink: link, name: item.name, rating: item.rating, category: cat, distance: dist, status: status, location: item.location)
        
        return model
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceCell,
            let model = cell.model else { return }
        
        if let manager = navigationManager {
            manager.stop()
            if let lastRoute = currentMapRoute {
                mapView.remove(mapObject: lastRoute)
            }
        }
        
        let placeLocation = model.location
        buildRoute(to: placeLocation)
        placeTableView.setContentOffset(CGPoint(x: 0, y: -maxTopContainerHeight), animated: true)
    }
}
