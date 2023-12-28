//
//  SceneDelegate.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let movieMainViewController = Dependencies.shared.movieMainViewController()
        window.rootViewController = UINavigationController(rootViewController: movieMainViewController)
        self.window = window
        window.makeKeyAndVisible()
    }

}
