//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by alekseevpg on 12.08.2023.
//

import Foundation

extension Double {
    var stringWithDegreeSign: String {
        "\(self, fractionDigits: 0)°"
    }
}
