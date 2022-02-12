//
//  ViewController.swift
//  myWeather
//
//  Created by QwertY on 21.01.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet private weak var currentWeatherCollectionView: UICollectionView!
    @IBOutlet private weak var weatherSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var containerView: UIView!
    
    static private let storyboardName = "Main"
    static private let identifier = "mainViewController"
    
    private lazy var detailsVC: DetailsViewController = {
        let storyboard = UIStoryboard(name: MainViewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DetailsViewController.identifier) as! DetailsViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var hoursVC: HoursViewController = {
        let storyboard = UIStoryboard(name: MainViewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: HoursViewController.identifier) as! HoursViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var daysVC: DaysViewController = {
        let storyboard = UIStoryboard(name: MainViewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DaysViewController.identifier) as! DaysViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    static private func viewController() -> MainViewController {
        return UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(identifier: self.identifier) as MainViewController
    }
    
    @IBAction private func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func setupCurrentWeatherCollectionView() {
        currentWeatherCollectionView.delegate = self
        currentWeatherCollectionView.dataSource = self
        getCurrentWeather() { locationName, weather in
            MyLocations.weather[locationName] = weather
            DispatchQueue.main.async {
                self.currentWeatherCollectionView.reloadData()
            }
        }
    }
    
    private func getCurrentWeather(completion: @escaping(String, Weather) -> Void) {
        for locationName in MyLocations.locationNames {
            let weatherNetworkManager = WeatherNetworkManager(locationName: locationName, forecastDays: 1)
            weatherNetworkManager.fetchWeather(completion: { result in
                switch result {
                case .failure(_):
                    print("error")
                case .success(let weather):
                    completion(locationName, weather)
                }
            })
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        switch weatherSegmentedControl.selectedSegmentIndex {
        case 0:
            switch weatherSegmentedControl.tag {
            case 1:
                remove(asChildViewController: hoursVC)
            case 2:
                remove(asChildViewController: daysVC)
            default:
                break
            }
            add(asChildViewController: detailsVC)
            weatherSegmentedControl.tag = 0
        case 1:
            switch weatherSegmentedControl.tag {
            case 0:
                remove(asChildViewController: detailsVC)
            case 2:
                remove(asChildViewController: daysVC)
            default:
                break
            }
            add(asChildViewController: hoursVC)
            weatherSegmentedControl.tag = 1
        case 2:
            switch weatherSegmentedControl.tag {
            case 0:
                remove(asChildViewController: detailsVC)
            case 1:
                remove(asChildViewController: hoursVC)
            default:
                break
            }
            add(asChildViewController: daysVC)
            weatherSegmentedControl.tag = 2
        default:
            break
        }
    }
    
    private func setupView() {
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrentWeatherCollectionView()
        setupView()
    }

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MyLocations.locationNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.identifier, for: indexPath as IndexPath) as! CurrentWeatherCollectionViewCell
        let locationName = MyLocations.locationNames[indexPath.row]
        guard let weather = MyLocations.weather[locationName] else { return cell }
        let temp = weather.current.temp_c
        let condition = weather.current.condition.text
        let location = weather.location.name
        cell.configureCell(temp: temp, condition: condition, location: location)
        return cell
    }
    
}
