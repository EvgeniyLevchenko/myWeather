//
//  DetailsTableViewCell.swift
//  myWeather
//
//  Created by QwertY on 09.03.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherElementImageView: UIImageView!
    @IBOutlet weak var weatherElementNameLabel: UILabel!
    @IBOutlet weak var weatherElementInfoLabel: UILabel!
    static let identifier = "DetailsTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(imageSystemName: String, weatherElementName: String, weatherElementInfo: String) {
        if let image = UIImage.init(systemName: imageSystemName) {
            weatherElementImageView.image = image
        }
        weatherElementNameLabel.text = weatherElementName
        weatherElementInfoLabel.text = weatherElementInfo
    }
}
