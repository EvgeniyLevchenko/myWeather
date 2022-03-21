//
//  UserLocationsTableViewCell.swift
//  myWeather
//
//  Created by QwertY on 13.03.2022.
//

import UIKit

class UserLocationsTableViewCell: UITableViewCell {

    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var currentConditionImageView: UIImageView!
    @IBOutlet private weak var currentTempLabel: UILabel!
    
    static let identifier = "UserLocationsTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    func configure(locationName: String, iconURL: String, temperature: Double) {
        locationNameLabel.text = locationName
        if let conditionIconURL = URL(string: "https:\(iconURL)") {
            currentConditionImageView.load(url: conditionIconURL)
        }
        currentTempLabel.text = "\(Int(round(temperature)))°"
    }
}
