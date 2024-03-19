//
//  WeatherData.swift
//  weatherApp
//
//  Created by Nisa Aydin on 6.02.2024.
//

import Foundation
struct WeatherData: Codable{
   
    let name:String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable {
    let temp: Double
    
}
struct Weather:Codable {
    let description: String
    let id: Int
}

