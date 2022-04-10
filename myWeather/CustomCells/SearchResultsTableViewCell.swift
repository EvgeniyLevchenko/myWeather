//
//  SearchResultsTableViewCell.swift
//  myWeather
//
//  Created by QwertY on 03.04.2022.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var locationRegionLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    
    static let identifier = "SearchResultsTableViewCell"
    let locationManager = WeatherNetworkManager()
    let userLocations = UserLocations()
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let locationName = locationNameLabel.text {
            addButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            addButton.isEnabled = false
            addNewLocation(named: locationName)
        }
    }
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(locationName: String, locationRegion: String, locationCountry: String) {
        if let _ =  UserLocations.weather[locationName] {
            addButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            addButton.isEnabled = false
        } else {
            addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addButton.isEnabled = true
        }
        locationNameLabel.text = locationName
        locationRegionLabel.text = "\(locationRegion), \(locationCountry)"
    }
    
    private func addNewLocation(named locationName: String) {
        userLocations.addLocation(name: locationName)
        userLocations.getAllLocations()
        locationManager.fetchWeather(forLocation: locationName, completion: { result in
            switch result {
            case .failure(_):
                print("adding location error")
            case .success(let weather):
                UserLocations.weather[locationName] = weather
            }
        })
    }
    
}
