//
//  UserLocationsViewController.swift
//  myWeather
//
//  Created by QwertY on 13.03.2022.
//

import UIKit

class UserLocationsViewController: UIViewController {

    @IBOutlet private weak var userLocationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserLocationsTableView()
    }
    
    private func setupUserLocationsTableView() {
        userLocationsTableView.delegate = self
        userLocationsTableView.dataSource = self
        userLocationsTableView.register(UserLocationsTableViewCell.nib(), forCellReuseIdentifier: UserLocationsTableViewCell.identifier)
        userLocationsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: userLocationsTableView.frame.size.width, height: 1))
    }

}

extension UserLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MyLocations.locationNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserLocationsTableViewCell.identifier, for: indexPath) as! UserLocationsTableViewCell
        let locationName = MyLocations.locationNames[indexPath.row]
        guard let currentWeather = MyLocations.weather[locationName]?.current else { return cell }
        let iconURL = currentWeather.condition.icon
        let temp = currentWeather.temp_c
        cell.configure(locationName: locationName, iconURL: iconURL, temperature: temp)
        return cell
    }
}
