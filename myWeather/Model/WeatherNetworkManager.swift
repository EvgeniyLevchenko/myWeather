//
//  WeatherNetworkManager.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

class WeatherNetworkManager {
    
    var resourceURL: URL
    let API_KEY = "7bc232b849cf4051b71200807222001"
    
    init(locationName: String, forecastDays: Int) {
        let resourceString = "https://api.weatherapi.com/v1/forecast.json?key=\(API_KEY)&q=\(locationName)&days=\(forecastDays)&aqi=no&alerts=no"
        
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    func fetchWeather(completion: @escaping(Result<Weather, WeatherError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: jsonData)
                completion(.success(weather))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
}
