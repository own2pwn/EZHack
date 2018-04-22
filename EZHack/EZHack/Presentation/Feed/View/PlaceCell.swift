//
//  PlaceCell.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import CoreLocation
import Kingfisher
import UIKit

enum PlaceStatusType: String {
    case open
    case closed
}

struct PlaceDisplayModel {
    let imageLink: String
    let name: String
    let rating: Double
    let category: String
    let distance: Double
    let status: PlaceStatusType
    let location: CLLocationCoordinate2D
}

protocol PlaceCellDelegate: class {
    func makeRoute(to point: CLLocationCoordinate2D)
}

final class PlaceCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet var placeImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var ratingLabel: UILabel!
    
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var statusLabel: UILabel!
    
    // MARK: - Setters
    
    var model: PlaceDisplayModel? {
        didSet {
            guard let model = model else { return }
            updateView(with: model)
        }
    }
    
    weak var delegate: PlaceCellDelegate?
    
    let cats: [String: Any] = ["entertainment": ["zoo", "casino", "night_club", "movie_theater", "aquarium", "amusement_park"],
                               "beauty": ["spa", "beauty_salon"],
                               "shopping": ["clothing_store", "shopping_mall", "store"],
                               "restaurant": "restaurant",
                               "park": ["park"],
                               "museum": ["church", "library", "art_gallery"],
                               "cafe": ["bakery", "cafe"],
                               "bar": ["bar"]]
    
//    entertainment [zoo, casino, night_club, movie_theater, aquarium, amusement_park]
//
//    beauty [spa, beauty_salon]
//
//
//    shopping [ clothing_store, shopping_mall, store]
//
//    restaurant [restaurant]
//
//    park [park]
//
//    museum [church, library, art_gallery]
//
//    cafe [bakery, cafe]
//
//    bar [bar]
    
    // MARK: - Update view
    
    private func updateView(with model: PlaceDisplayModel) {
        // placeImageView.image = model.image
        
        nameLabel.text = model.name
        ratingLabel.text = "(\(model.rating.rounded()))"
        categoryLabel.text = model.category
        
        let badCat = model.category
        for key in cats.keys {
            guard let values = cats[key] as? [String] else { return }
            if values.contains(badCat) {
                categoryLabel.text = key
                break
            }
        }
        
        let dist = Int(model.distance.rounded())
        distanceLabel.text = "\(dist) m"
        
        switch model.status {
        case .open:
            statusLabel.textColor = #colorLiteral(red: 0.262835294, green: 0.8022480607, blue: 0.3886030316, alpha: 1)
        case .closed:
            statusLabel.textColor = #colorLiteral(red: 0.8881979585, green: 0.3072378635, blue: 0.2069461644, alpha: 1)
        }
        
        statusLabel.text = model.status.rawValue
        
        let link = model.imageLink
        
        if link.contains("http") {
            let url = URL(string: model.imageLink)
            placeImageView.kf.setImage(with: url)
        } else {
            // let size = placeImageView.frame.size
            let maxWidth = 250 // Int(size.width)
            let maxHeight = 250 // Int(size.height)
            
            let constructedLink = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxWidth)&maxheight=\(maxHeight)&key=\(PlaceProvider.apiKEY)&photoreference=\(link)"
            
            let url = URL(string: constructedLink)
            placeImageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func makeRoute(_ sender: Any) {
        delegate?.makeRoute(to: model!.location)
    }
}
