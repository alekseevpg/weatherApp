//
//  String+Interpolation.swift
//  WeatherApp
//
//  Created by alekseevpg on 03.02.2023.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(_ number: Int, digits: Int) {
        appendLiteral(String(format: "%0\(digits)d", number))
    }

    mutating func appendInterpolation(_ number: Double, fractionDigits: Int) {
        appendLiteral(String(format: "%.\(fractionDigits)f", number))
    }

    mutating func appendInterpolation(_ number: Float, fractionDigits: Int) {
        appendLiteral(String(format: "%.\(fractionDigits)f", number))
    }

    mutating func appendInterpolation(_ number: CGFloat, fractionDigits: Int) {
        appendLiteral(String(format: "%.\(fractionDigits)f", number))
    }
}
