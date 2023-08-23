//
//  CityView.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import SwiftUI

@MainActor
struct WeatherDetailsView: View {
    let cityWeather: CityWeatherInfo
    let animation: Namespace.ID

    var body: some View {
        ScrollView(showsIndicators: false) {
            headerView
            forecastView
            detailsView
        }
        .foregroundColor(.primary(night: cityWeather.isNight))
        .background {
            Color.accent(night: cityWeather.isNight)
                .matchedGeometryEffect(id: "background\(cityWeather.id)", in: animation)
                .edgesIgnoringSafeArea(.all)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Text(cityWeather.cityName)
                .font(.system(size: 30, weight: .medium))
                .matchedGeometryEffect(id: cityWeather.cityName.appending(cityWeather.id), in: animation)

            HStack {
                if let weather = cityWeather.weather.first {
                    LottieView(name: weather.lottieAnimationName)
                        .frame(width: 100, height: 100)
                }
                Text(cityWeather.temp.stringWithDegreeSign)
                    .font(.system(size: 70, weight: .medium))
                    .matchedGeometryEffect(id: cityWeather.temp.stringWithDegreeSign.appending(cityWeather.id), in: animation)
            }

            if let weather = cityWeather.weather.first {
                Text(weather.description.capitalized)
                    .font(.system(size: 20, weight: .medium))
                    .matchedGeometryEffect(id: weather.description.appending(cityWeather.id), in: animation)
            }
            HStack {
                Text("H:\(cityWeather.tempMax.stringWithDegreeSign)")
                    .matchedGeometryEffect(id: cityWeather.tempMax.stringWithDegreeSign.appending("H\(cityWeather.id)"), in: animation)
                Text("L:\(cityWeather.tempMin.stringWithDegreeSign)")
                    .matchedGeometryEffect(id: cityWeather.tempMin.stringWithDegreeSign.appending("L\(cityWeather.id)"), in: animation)
            }
            .font(.system(size: 20, weight: .medium))
            Spacer()
        }
        .minimumScaleFactor(0.1)
    }
    
    private var forecastView: some View {
        Group {
            if cityWeather.forecast.isEmpty {
                EmptyView()
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                        Text("HOURLY FORECAST")
                            .font(.caption)
                        Spacer()
                    }

                    Rectangle()
                        .fill(Color.primary(night: cityWeather.isNight).opacity(0.5))
                        .frame(height: 1)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(cityWeather.forecast) { forecast in
                                VStack(spacing: 0) {
                                    Text(DateFormatter.dateFormatter.string(from: forecast.date))
                                        .font(.caption)
                                    Spacer()
                                    Text("\(forecast.tempMax.stringWithDegreeSign)")
                                        .fontWeight(.medium)
                                }
                                .frame(height: 80)
                                .overlay {
                                    Group {
                                        if let weather = forecast.weather.first {
                                            Image(systemName: weather.systemIconName)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
                .padding(.horizontal)
            }
        }
    }

    private var detailsView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(170)), count: 2)) {
            ForEach(cityWeather.details) { detail in
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: detail.icon)
                        Text(detail.title.uppercased())
                            .font(.caption)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    Text(detail.message)
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                    Spacer()
                }
                .frame(width: 150, height: 150)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.vertical, 10)
            }
        }
    }
}

extension WeatherDetails: Identifiable {
    var id: String { message }
}

private extension WeatherDetails {
    var icon: String {
        switch self {
        case .visibility:
            return "eye.fill"
        case .feelsLike:
            return "thermometer.medium"
        case .humidiy:
            return "humidity"
        case .pressure:
            return "gauge.medium"
        case .wind:
            return "wind"
        case .rain:
            return "drop.fill"
        }
    }

    var title: String {
        switch self {
        case .visibility:
            return "Visibility"
        case .feelsLike:
            return "Feels Like"
        case .humidiy:
            return "Humidity"
        case .pressure:
            return "Pressure"
        case .wind:
            return "Wind"
        case .rain:
            return "Rain"
        }
    }

    var message: String {
        switch self {
        case .visibility(let km):
            return "\(km) km"
        case .feelsLike(let degrees):
            return "\(degrees)°"
        case .humidiy(let percent):
            return "\(percent) %"
        case .pressure(let mm):
            return "\(mm)\nmm Hg"
        case .wind(let ms):
            return "\(ms) m/s"
        case .rain(let mm):
            return "\(mm)\n mm today"
        }
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        WeatherDetailsView(cityWeather: .placeholder(id: "1"), animation: animation)
    }
}
