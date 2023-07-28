//
//  SettingCoodinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class SettingCoordinator: Coordinator {
    weak var parentCoordinator: MainTabBarCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SettingTabBarController()
        controller.coordinator = self
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentProfileSettingViewController() {
        let coordinator = ProfileSettingCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
