//
//  Loсation.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

struct Location: Codable {
    var name: String
    var region: String
    var country: String
    var lat: Double
    var lon: Double
    var tz_id: String
    var localtime_epoch: Int
    var localtime: String
}
