//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by alekseevpg on 30.03.2023.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        Logging.start()
        return true
    }

    //MARK: - Configuring and Discarding Scenes
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

//MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func sceneDidBecomeActive(_ scene: UIScene) {
        log.debug("did become active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        log.debug("will resign active")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        log.debug("did enter background")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        log.debug("will enter foreground")
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        log.debug("will openURLContexts")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        log.debug("will willConnectTo")
    }
}
