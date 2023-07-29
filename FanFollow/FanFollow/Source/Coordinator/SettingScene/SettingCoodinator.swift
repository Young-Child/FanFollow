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
    
    func presentSettingDetailController(to viewType: SettingSectionItem.PresentType) {
        let coordinator = generateCoordinator(to: viewType, with: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

private extension SettingCoordinator {
    func generateCoordinator(
        to viewType: SettingSectionItem.PresentType,
        with navigationController: UINavigationController
    ) -> Coordinator {
        switch viewType {
        case .profile:
            return ProfileSettingCoordinator(navigationController: navigationController)
        default:
            return ProfileSettingCoordinator(navigationController: navigationController)
        }
    }
}