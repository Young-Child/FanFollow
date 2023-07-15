//
//  SceneDelegate.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import UIKit
import Kingfisher

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setKingFisherModifier()
        
        window = UIWindow(windowScene: windowScene)
        let controller = TabBarController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    func setKingFisherModifier() {
        let modifier = AnyModifier { request in
            var request = request
            
            request.setValue(Bundle.main.apiKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer " + Bundle.main.apiKey, forHTTPHeaderField: "Authorization")
            return request
        }
        
        KingfisherManager.shared.defaultOptions = [.requestModifier(modifier)]
    }
}
