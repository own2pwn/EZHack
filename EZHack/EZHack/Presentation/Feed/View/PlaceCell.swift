//
//  PlaceCell.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

enum PlaceStatusType: String {
    case open = "открыто"
    case closed = "не работает"
}

struct PlaceDisplayModel {
    let image: UIImage
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
    
    var model: PlaceDisplayModel?
    
    // MARK: - Update view
    
    private func updateView(with model: PlaceDisplayModel) {
        placeImageView.image = model.image
        nameLabel.text = model.name
        ratingLabel.text = "(\(model.rating.rounded()))"
        categoryLabel.text = model.category
        distanceLabel.text = "\(model.distance.rounded()) "
        statusLabel.text = model.status.rawValue
    }
}
