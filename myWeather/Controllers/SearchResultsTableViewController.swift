//
//  SearchResultsTableViewController.swift
//  myWeather
//
//  Created by QwertY on 03.04.2022.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    private let networkManager = WeatherNetworkManager()
    private var locations: [SearchLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(SearchResultsTableViewCell.nib(), forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections = 0
        if locations.isEmpty {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No results found"
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath) as! SearchResultsTableViewCell
        let name = locations[indexPath.row].name
        let region = locations[indexPath.row].region
        let country  = locations[indexPath.row].country
        cell.configure(locationName: name, locationRegion: region, locationCountry: country)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchResultsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        networkManager.searchLocation(withName: text, completion: { result in
            switch result {
            case .failure(_):
                print("failure")
            case .success(let locations):
                self.locations = locations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}
