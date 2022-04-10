//
//  MyLocations.swift
//  myWeather
//
//  Created by QwertY on 09.02.2022.
//

import UIKit
import CoreLocation

class UserLocations {
//    static var locationNames = ["Mezhova", "Berlin", "London", "Prague"]
    
    static var weather: [String : Weather] = [:]
    
    static var displayedLocationIndex: Int {
        get {
            return number
        }
        set {
            number = max(newValue, 0)
        }
    }
    
    static var number: Int = 0 {
        willSet(newIndex) {
            if newIndex != number {
                diplayedLocationChanged?()
            }
        }
    }
    
    static var diplayedLocationChanged: (() -> Void)?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var locationNames = [CoreLocation]()
    
    func getAllLocations() {
        do {
            UserLocations.locationNames = try context.fetch(CoreLocation.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func addLocation(name: String) {
        let newLocation = CoreLocation(context: context)
        newLocation.name = name
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteLocation(location: CoreLocation) {
        context.delete(location)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

}
