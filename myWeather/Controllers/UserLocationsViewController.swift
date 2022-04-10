//
//  UserLocationsViewController.swift
//  myWeather
//
//  Created by QwertY on 13.03.2022.
//

import UIKit

class UserLocationsViewController: UIViewController {

    @IBOutlet private weak var userLocationsTableView: UITableView!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    let storyboardName = "Main"
    let locationManager = WeatherNetworkManager()
    let userLocations = UserLocations()
    
    private lazy var searchResultsTableVC: SearchResultsTableViewController = {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let searchResultsTableVC = storyboard.instantiateViewController(withIdentifier: "searchResults") as! SearchResultsTableViewController
        return searchResultsTableVC
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsTableVC)
        searchController.searchResultsUpdater = searchResultsTableVC
        return searchController
    }()
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if userLocationsTableView.isEditing == true {
            userLocationsTableView.isEditing = false
            editButton.title = "Edit"
        } else {
            userLocationsTableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserLocationsTableView()
        setupSearchController()
    }
    
    private func setupUserLocationsTableView() {
        userLocationsTableView.delegate = self
        userLocationsTableView.dataSource = self
        userLocationsTableView.register(UserLocationsTableViewCell.nib(), forCellReuseIdentifier: UserLocationsTableViewCell.identifier)
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.delegate = self
    }

}

extension UserLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserLocations.locationNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserLocationsTableViewCell.identifier, for: indexPath) as! UserLocationsTableViewCell
        guard let locationName = UserLocations.locationNames[indexPath.row].name else { return cell }
        guard let currentWeather = UserLocations.weather[locationName]?.current else { return cell }
        let iconURL = currentWeather.condition.icon
        let temp = currentWeather.temp_c
        cell.configure(locationName: locationName, iconURL: iconURL, temperature: temp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = UserLocations.locationNames[indexPath.row]
            guard let locationName = location.name else { return}
            userLocations.deleteLocation(location: location)
            UserLocations.weather[locationName] = nil
            UserLocations.locationNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension UserLocationsViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        view.blurView()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        view.removeBlur()
        userLocationsTableView.reloadData()
    }
}

extension UIView {
    
    func blurView() {
        var blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    func removeBlur() {
        for view in self.subviews {
            if let view = view as? UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
}
