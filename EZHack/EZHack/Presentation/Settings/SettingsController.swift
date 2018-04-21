//
//  SettingsController.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import fluid_slider
import UIKit

final class SettingsController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var distanceSlider: Slider!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    // MARK: - Methods
    
    private func setupScreen() {
        setup()
    }
    
    private func setup() {
        let setup = [setColors, setupSlider]
        setup.forEach { $0() }
    }
    
    private func setColors() {
    }
    
    private func setupSlider() {
        let labelTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.white]
        distanceSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 4
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 5_000 + 200) as NSNumber) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.black])
        }
        distanceSlider.setMinimumLabelAttributedText(NSAttributedString(string: "200", attributes: labelTextAttributes))
        distanceSlider.setMaximumLabelAttributedText(NSAttributedString(string: "5 000", attributes: labelTextAttributes))
        distanceSlider.fraction = 0.5
        distanceSlider.shadowOffset = CGSize(width: 0, height: 10)
        distanceSlider.shadowBlur = 5
        distanceSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        distanceSlider.contentViewColor = #colorLiteral(red: 0.2222073078, green: 0.6842822433, blue: 0.3299767971, alpha: 1)
        distanceSlider.valueViewColor = .white
        distanceSlider.didBeginTracking = { [weak self] slider in
            log.debug("value: \(slider.fraction * 5_000 + 200)")
        }
        distanceSlider.didEndTracking = { [weak self] slider in
            log.debug("value: \(slider.fraction * 5_000 + 200)")
        }
        
        distanceSlider.fraction = (2_500 - 200) / 5_000
    }
}
