//
//  SettingsController.swift
//  EZHack
//
//  Created by supreme on 21/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import fluid_slider
import M13Checkbox
import UIKit

enum SortType {
    case distance
    case rating
}

public extension Bool {
    public mutating func toggle() {
        self = !self
    }
}

final class SettingsController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var distanceSlider: Slider!
    
    @IBOutlet var useWeatherView: UIView!
    
    @IBOutlet var checkboxButton: M13Checkbox!
    
    @IBOutlet var nonWorkingView: UIView!
    
    @IBOutlet var nonWorkingCheckbox: M13Checkbox!
    
    @IBOutlet var titleTableView: UITableView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        [checkboxButton, nonWorkingCheckbox].forEach { $0.setCheckState(.checked, animated: false) }
    }
    
    // MARK: - Members
    
    private var shouldConsiderWeather = false
    
    private var sortType: SortType = .distance
    
    private var shouldConsiderClosed = false
    
    let categoryTitles = ["Entertainment", "Beauty", "shopping", "restaurant", "park", "museum",
                          "cafe", "bar"].map { $0.capitalized }
    
    // MARK: - Methods
    
    private func setupScreen() {
        setup()
    }
    
    private func setup() {
        let setup = [setColors, setupSlider]
        setup.forEach { $0() }
        
        useWeatherView.tapHandler = onWeatherTap
        nonWorkingView.tapHandler = onNonWorkingTap
        
        titleTableView.tableFooterView = UIView()
    }
    
    //
    
    private func onWeatherTap() {
        checkboxButton.toggleCheckState(true)
        toggleConsiderWeather(checkboxButton)
    }
    
    @IBAction func toggleConsiderWeather(_ sender: M13Checkbox) {
        shouldConsiderWeather.toggle()
    }
    
    //
    
    private func onNonWorkingTap() {
        nonWorkingCheckbox.toggleCheckState(true)
        toggleNonWorking(nonWorkingCheckbox)
    }
    
    @IBAction func toggleNonWorking(_ sender: M13Checkbox) {
        shouldConsiderClosed.toggle()
    }
    
    //
    
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
    
    // MARK: - Actions
    
    @IBAction func changeSort(_ sender: UISegmentedControl) {
        sortType = sender.selectedSegmentIndex == 0 ? .distance : .rating
    }
}

extension SettingsController: UITableViewDelegate {
}

extension SettingsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(at: indexPath)
        
        let item = categoryTitles[indexPath.row]
        cell.titleLabel.text = item
        cell.selectionStyle = .none
        cell.checkboxButton.boxType = .square
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsCell {
            cell.checkboxButton.toggleCheckState(true)
        }
    }
}
