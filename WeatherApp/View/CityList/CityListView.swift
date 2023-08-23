//
//  HomeView.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import SwiftUI

@MainActor
struct CityListView: View {
    @Environment(\.scenePhase) private var scenePhase

    @Namespace private var animation

    @State private var selectedDetails: CityWeatherInfo?

    @StateObject private var viewModel = CityListViewModel(
        weatherService: DependencyContainer.shared.resolve(),
        locationService: DependencyContainer.shared.resolve()
    )

    var body: some View {
        Group {
            if let selectedDetails = selectedDetails {
                detailsView(selectedDetails: selectedDetails)
                    .transition(.fly)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Weather")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    ScrollView {
                        VStack {
                            if viewModel.locationServicesRestricted {
                                locationButton
                            }
                            ForEach(viewModel.weathers) { weather in
                                Button {
                                    guard !viewModel.isLoading else { return }
                                    withAnimation(.spring()) {
                                        self.selectedDetails = weather
                                    }
                                } label: {
                                    CityWeatherCellView(cityWeather: weather, animation: animation)
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(.primary(night: weather.isNight))
                            }
                            .redacted(reason: viewModel.isLoading ? .placeholder : [])
                        }
                        .padding()
                    }
                }
                .background(LinearGradient.appBackground)
            }
        }
        .background(LinearGradient.appBackground)
        .animation(.spring(), value: selectedDetails)
        .onAppear {
            Task {
                await viewModel.fetchWeather()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.fetchWeather()
                }
            }
        }
        .emittingError($viewModel.backendError) {
            await viewModel.fetchWeather()
        }
    }

    private func detailsView(selectedDetails: CityWeatherInfo) -> some View {
        VStack(spacing: 0) {
            WeatherDetailsView(cityWeather: selectedDetails, animation: animation)
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        self.selectedDetails = nil
                    }
                } label: {
                    Image(systemName: "list.bullet")
                        .padding()
                }
                .foregroundColor(Color.primary(night: selectedDetails.isNight))
            }
            .background(
                Color.accent(night: selectedDetails.isNight)
                    .edgesIgnoringSafeArea(.bottom)
                    .background(.ultraThinMaterial)
            )
        }
    }

    private var locationButton: some View {
        LoadingButton {
            await viewModel.requestAuthorization()
        } label: {
            HStack{
                Image(systemName: "location.circle.fill")
                Text("Tap to get current location")
                    .font(.title2)
                    .frame(height: 70)
            }
            .foregroundColor(.appPrimary)
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background {
            Color.accent(night: false)
        }
        .cornerRadius(15)
        .buttonStyle(.plain)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}
