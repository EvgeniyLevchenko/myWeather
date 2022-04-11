//
//  ViewController.swift
//  myWeather
//
//  Created by QwertY on 21.01.2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet private weak var locationsPageControl: UIPageControl!
    @IBOutlet private weak var currentWeatherCollectionView: UICollectionView!
    @IBOutlet private weak var weatherSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var containerView: UIView!
    
    static private let storyboardName = "Main"
    static private let identifier = "mainViewController"
    
    private let userLocations = UserLocations()
    
    private lazy var detailsVC: DetailsViewController = {
        let storyboard = UIStoryboard(name: MainViewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DetailsViewController.identifier) as! DetailsViewController
        self.add(viewController)
        return viewController
    }()
    
    private lazy var hoursVC: HoursViewController = {
        let storyboard = UIStoryboard(name: MainViewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: HoursViewController.identifier) as! HoursViewController
        self.add(viewController)
        return viewController
    }()
    
    private lazy var daysVC: DaysViewController = {
        let storyboard = UIStoryboard(name: MainViewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DaysViewController.identifier) as! DaysViewController
        self.add(viewController)
        return viewController
    }()
    
    static private func viewController() -> MainViewController {
        return UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(identifier: self.identifier) as MainViewController
    }
    
    @IBAction private func segmentValueChanged(_ sender: UISegmentedControl) {
        updateContainerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateView()
    }
    
    private func loadCoreData() {
        userLocations.getAllLocations()
        if UserLocations.locationNames.isEmpty {
            userLocations.addLocation(name: "Mezhova")
            userLocations.getAllLocations()
        }
    }
    
    private func setupView() {
        setupCurrentWeatherCollectionView()
        setupSegmentedControl()
        setuplocationsPageControl()
        updateContainerView()
    }
    
    private func setuplocationsPageControl() {
        locationsPageControl.numberOfPages = UserLocations.locationNames.count
    }
    
    private func setupCurrentWeatherCollectionView() {
        currentWeatherCollectionView.delegate = self
        currentWeatherCollectionView.dataSource = self
        currentWeatherCollectionView.register(CurrentWeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: CurrentWeatherCollectionViewCell.identifier)
        getCurrentWeather() { locationName, weather in
            UserLocations.weather[locationName] = weather
            DispatchQueue.main.async {
                self.currentWeatherCollectionView.reloadData()
            }
        }
    }
    
    private func setupSegmentedControl() {
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray6]
        weatherSegmentedControl.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        weatherSegmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        weatherSegmentedControl.layer.borderWidth = 1.0
        weatherSegmentedControl.layer.cornerRadius = 1.0
        weatherSegmentedControl.layer.backgroundColor = UIColor.systemBlue.cgColor
        weatherSegmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        weatherSegmentedControl.selectedSegmentTintColor = .systemBlue
        weatherSegmentedControl.backgroundColor = .systemGray6
        weatherSegmentedControl.tintColor = .systemBlue
    }
    
    private func getCurrentWeather(completion: @escaping(String, Weather) -> Void) {
        for locationName in UserLocations.locationNames {
            let weatherNetworkManager = WeatherNetworkManager()
            guard let name = locationName.name else { return }
            weatherNetworkManager.fetchWeather(forLocation: name, completion: { result in
                switch result {
                case .failure(_):
                    print("error")
                case .success(let weather):
                    completion(name, weather)
                }
            })
        }
    }
    
    private func updateContainerView() {
        let selectedSegment = weatherSegmentedControl.selectedSegmentIndex
        if let segment = Segment(rawValue: selectedSegment) {
            switch segment {
            case .details:
                let tag = weatherSegmentedControl.tag
                if let previousSegment = Segment(rawValue: tag) {
                    switch previousSegment {
                    case .hours:
                        remove(hoursVC)
                    case .days:
                        remove(daysVC)
                    case .details:
                        break
                    }
                }
                detailsVC.updateDetailsView()
                add(detailsVC)
                weatherSegmentedControl.tag = Segment.details.rawValue
            case .hours:
                let tag = weatherSegmentedControl.tag
                if let previousSegment = Segment(rawValue: tag) {
                    switch previousSegment {
                    case .details:
                        remove(detailsVC)
                    case .days:
                        remove(daysVC)
                    case .hours:
                        break
                    }
                }
                hoursVC.updateHourlyTableView()
                add(hoursVC)
                weatherSegmentedControl.tag = Segment.hours.rawValue
            case .days:
                let tag = weatherSegmentedControl.tag
                if let previousSegment = Segment(rawValue: tag) {
                    switch previousSegment {
                    case .details:
                        remove(detailsVC)
                    case .hours:
                        remove(hoursVC)
                    case .days:
                        break
                    }
                }
                daysVC.updateDaylyWeatherTableView()
                add(daysVC)
                weatherSegmentedControl.tag = Segment.days.rawValue
            }
        }
    }
    
    private func add(_ viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        setuplocationsPageControl()
        DispatchQueue.main.async {
            self.currentWeatherCollectionView.reloadData()
        }
        updateContainerView()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserLocations.locationNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.identifier, for: indexPath as IndexPath) as! CurrentWeatherCollectionViewCell
        guard let locationName = UserLocations.locationNames[indexPath.row].name else { return cell }
        guard let weather = UserLocations.weather[locationName] else { return cell }
        let temp = weather.current.temp_c
        let condition = weather.current.condition.text
        let location = weather.location.name
        let conditionIcon = weather.current.condition.icon
        cell.configure(temp: temp, condition: condition, location: location, iconURL: conditionIcon)
        return cell
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UserLocations.displayedLocationIndex = Int(round(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        locationsPageControl.currentPage = UserLocations.displayedLocationIndex
    }
}
