//
//  MapViewController.swift
//  myWeather
//
//  Created by QwertY on 10.04.2022.
//

import UIKit
import MapKit
import Contacts

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    
    var displayingLocation: Location?
    
    @IBAction func leftChangeLocationButtonTapped(_ sender: Any) {
        centerToPrevLocation()
    }
    
    @IBAction func rightChangeLocationButtonTapped(_ sender: Any) {
        centerToNextLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerToInitialLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addPlacemarks()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removePlacemarks()
    }
    
    private func addPlacemarks() {
        for location in UserLocations.locationNames {
            if let locationName = location.name {
                if let weatherLocation = UserLocations.weather[locationName]?.location {
                    addPlacemark(for: weatherLocation)
                }
            }
        }
    }
    
    private func addPlacemark(for location: Location) {
        let latitude = location.lat
        let longitude = location.lon
        let locationName = location.name
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let address = [CNPostalAddressCityKey: locationName, CNPostalAddressCountryKey : " "]
        let place = MKPlacemark(coordinate: coordinates, addressDictionary: address)
        mapView.addAnnotation(place)
    }
    
    private func removePlacemarks() {
        mapView.removeAnnotations(mapView.annotations)
    }

    private func centerToInitialLocation() {
        if let location = UserLocations.locationNames.first {
            if let locationName = location.name {
                if let weatherLocation = UserLocations.weather[locationName]?.location {
                    mapView.centerToLocation(weatherLocation)
                    displayingLocation = weatherLocation
                }
            }
        }
    }
    
    private func centerToNextLocation() {
        let locations = UserLocations.locationNames
        guard let currentIndex = locations.firstIndex(where: {
            $0.name == displayingLocation?.name
        }) else {
            centerToInitialLocation()
            return
        }
        
        if currentIndex + 1 < locations.count {
            if let locationName = locations[currentIndex + 1].name {
                if let weatherLocation = UserLocations.weather[locationName]?.location {
                    mapView.centerToLocation(weatherLocation)
                    displayingLocation = weatherLocation
                }
            }
        } else {
            if let locationName = locations.first?.name {
                if let weatherLocation = UserLocations.weather[locationName]?.location {
                    mapView.centerToLocation(weatherLocation)
                    displayingLocation = weatherLocation
                }
            }
        }
    }
    
    private func centerToPrevLocation() {
        let locations = UserLocations.locationNames
        guard let currentIndex = locations.firstIndex(where: {
            $0.name == displayingLocation?.name
        }) else {
            centerToInitialLocation()
            return
        }
        
        if currentIndex > 0 {
            if let locationName = locations[currentIndex - 1].name {
                if let weatherLocation = UserLocations.weather[locationName]?.location {
                    mapView.centerToLocation(weatherLocation)
                    displayingLocation = weatherLocation
                }
            }
        } else {
            if let locationName = locations.last?.name {
                if let weatherLocation = UserLocations.weather[locationName]?.location {
                    mapView.centerToLocation(weatherLocation)
                    displayingLocation = weatherLocation
                }
            }
        }
    }
}

private extension MKMapView {
    
    func centerToLocation(_ location: Location, regionRadius: CLLocationDistance = 8000) {
        let latitude = location.lat
        let longitude = location.lon
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
