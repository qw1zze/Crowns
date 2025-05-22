//
//  SceneDelegate.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 4/3/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let mainViewController = MainAssembly.assembly()
        window.rootViewController = UINavigationController(rootViewController: mainViewController)
        window.makeKeyAndVisible()
        self.window = window
    }
}
