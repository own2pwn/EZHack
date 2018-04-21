//
//  PlaceCell.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Kingfisher
import UIKit

enum PlaceStatusType: String {
    case open = "открыто"
    case closed = "не работает"
}

struct PlaceDisplayModel {
    let imageLink: String
    let name: String
    let rating: Double
    let category: String
    let distance: Double
    let status: PlaceStatusType
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
    
    // MARK: - Update view
    
    private func updateView(with model: PlaceDisplayModel) {
        // placeImageView.image = model.image
        
        nameLabel.text = model.name
        ratingLabel.text = "(\(model.rating.rounded()))"
        categoryLabel.text = model.category
        distanceLabel.text = "\(model.distance.rounded()) "
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
}
