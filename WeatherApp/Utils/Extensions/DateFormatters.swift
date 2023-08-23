//
//  DateFormatters.swift
//  WeatherApp
//
//  Created by Pavel Alekseev.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = .gmt
        return dateFormatter
    }()
}
