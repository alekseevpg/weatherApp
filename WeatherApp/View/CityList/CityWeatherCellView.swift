//
//  CityWeatherCellView.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import SwiftUI

@MainActor
struct CityWeatherCellView: View {
    @Environment(\.redactionReasons) var redactionReasons

    let cityWeather: CityWeatherInfo
    let animation: Namespace.ID

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 32) {
                Text(cityWeather.cityName)
                    .font(.system(size: 20, weight: .medium))
                    .matchedGeometryEffect(id: cityWeather.cityName.appending(cityWeather.id), in: animation)
                if let weather = cityWeather.weather.first {
                    Text(weather.description.capitalized)
                        .font(.system(size: 15, weight: .medium))
                        .matchedGeometryEffect(id: weather.description.appending(cityWeather.id), in: animation)
                }
            }
            Spacer()
            VStack(alignment: .center, spacing: 32) {
                Text(cityWeather.temp.stringWithDegreeSign)
                    .font(.system(size: 20, weight: .medium))
                    .matchedGeometryEffect(id: cityWeather.temp.stringWithDegreeSign.appending(cityWeather.id), in: animation)

                HStack {
                    Text("H:\(cityWeather.tempMax.stringWithDegreeSign)")
                        .matchedGeometryEffect(id: cityWeather.tempMax.stringWithDegreeSign.appending("H\(cityWeather.id)"), in: animation)
                    Text("L:\(cityWeather.tempMin.stringWithDegreeSign)")
                        .matchedGeometryEffect(id: cityWeather.tempMin.stringWithDegreeSign.appending("L\(cityWeather.id)"), in: animation)
                }
                .font(.system(size: 15, weight: .medium))
            }
        }
        .minimumScaleFactor(0.1)
        .frame(maxHeight: 80)
        .padding()
        .background {
            Color.accent(night: cityWeather.isNight)
                .matchedGeometryEffect(id: "background\(cityWeather.id)", in: animation)
        }
        .overlay(alignment: .top) {
            Group {
                if let weather = cityWeather.weather.first, redactionReasons.isEmpty {
                    LottieView(name: weather.lottieAnimationName)
                        .frame(width: 80, height: 70)
                }
            }
        }
        .cornerRadius(15)
    }
}

struct CityWeatherCellView_Previews: PreviewProvider {
    @Namespace static var animation

    static var previews: some View {
        CityWeatherCellView(cityWeather: CityWeatherInfo.placeholder(id: "1"), animation: animation)
    }
}
