//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by alekseevpg on 01.02.2023.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let notificationCenter = UNUserNotificationCenter.current()

    var body: some Scene {
        WindowGroup {
            Group {
                CityListView()
            }
            .background(LinearGradient.appBackground)
            .onAppear {
                // This is seems to be fixing Apple bug where if LocationAuthorization is denied, app doesn't appear in Settings menu
                // So you can't change authorization until reinstalling the app
                notificationCenter.requestAuthorization(options: [.alert]) { _, _ in
                }
            }
        }
    }
}
