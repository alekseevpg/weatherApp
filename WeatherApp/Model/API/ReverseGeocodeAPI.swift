//
//  ReverseGeocodeAPI.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import Foundation

struct ReverseGeocodeAPI: Decodable {
    let name: String
    let lat, lon: Double
    let country: String
}
