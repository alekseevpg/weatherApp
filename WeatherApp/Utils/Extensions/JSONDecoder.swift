//
//  JSONDecoder.swift
//  WeatherApp
//
//  Created by alekseevpg on 13.08.2023.
//

import Foundation

extension JSONDecoder {
    static let weatherAppDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}
