//
//  MyLocations.swift
//  myWeather
//
//  Created by QwertY on 09.02.2022.
//

import Foundation

struct MyLocations {
    static var locationNames = ["Mezhova", "Berlin", "London", "Prague"]
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
}
