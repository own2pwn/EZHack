//
//  SettingsCell.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import M13Checkbox
import UIKit

final class SettingsCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var checkboxButton: M13Checkbox!

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        checkboxButton.setCheckState(.checked, animated: false)
    }
}
