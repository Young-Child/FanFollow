//
//  SceneDelegate.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import UIKit

import Kingfisher

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        
        mainCoordinator = AppCoordinator(navigationController: navigationController)
        mainCoordinator?.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
