//
//  AppCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: - 추후 로그인 기능과 함께 사용할 수 있도록 구현
        presentMainView(authKey: "")
    }
    
    func presentMainView(authKey: String) {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
