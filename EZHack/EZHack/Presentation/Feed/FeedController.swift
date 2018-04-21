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
import UIKit

final class FeedController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var placeTableView: UITableView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    // MARK: - Members
    
    private let locator = LocationManager()
    
    private let provider = PlaceProvider.shared
    
    private var placesClient: GMSPlacesClient!
    
    private var datasource: [PlaceModel] = []
    
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
            .then(getNearbyPlaces)
    }
    
    private func getNearbyPlaces(_ location: CLLocation) {
        provider.get(by: location.coordinate).then(updateView)
    }
    
    private func updateView(with placeList: [PlaceModel]) {
        let me = locator.lastKnownLocation!
        datasource = placeList.sorted(by: PlaceModel.DistanceSorter(me: me))
        placeTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func retestLocation(_ sender: UIButton) {
        testMyLocation()
    }
}

extension FeedController: UITableViewDelegate {
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
        
        let model = PlaceDisplayModel(imageLink: link, name: item.name, rating: item.rating, category: cat, distance: dist, status: status)
        
        return model
    }
}
