//
//  DaysTableViewCell.swift
//  myWeather
//
//  Created by QwertY on 09.03.2022.
//

import UIKit

class DaysTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var conditionIcon: UIImageView!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    
    static let identifier = "DaysTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    func configure(dayOfWeek: String, iconURL: String, minTemp: Double, maxTemp: Double) {
        dayOfWeekLabel.text = dayOfWeek
        if let conditionIconURL = URL(string: "https:\(iconURL)") {
            conditionIcon.load(url: conditionIconURL)
        }
        minTempLabel.text = "\(Int(round(minTemp)))°"
        maxTempLabel.text = "\(Int(round(maxTemp)))°"
    }

}
