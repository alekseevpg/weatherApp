//
//  Colors.swift
//  WeatherApp
//
//  Created by alekseevpg on 03.02.2023.
//

import SwiftUI

extension SwiftUI.Color {
    var uiColor: UIColor {
        UIColor(self)
    }
}

extension SwiftUI.Color {

    static let appPrimary = Color(hex: "2F2F2F")
    static let accent = Color(hex: "45b6d6")
    static let accentDark = Color(hex: "1d4368")

    static func accent(night: Bool) -> Color {
        night ? .accentDark : accent
    }

    static func primary(night: Bool) -> Color {
        night ? .white : .appPrimary
    }
}

extension LinearGradient {

    static var appBackground = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "9eb7d5"), Color(hex: "15ced1")]),
        startPoint: .top,
        endPoint: .bottom
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
