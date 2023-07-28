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
    
    func presentSettingDetailController(to viewType: SettingPresentAction) {
        let coordinator = viewType.coordinator(with: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}

extension SettingCoordinator {
    enum SettingPresentAction {
        case profile
        case creator
        case alert
        case bugReport
        case evaluation
        case privacy
        case openSource
        case logOut
        case registerOut
        
        func coordinator(with navigationController: UINavigationController) -> Coordinator {
            switch self {
            case .profile:
                let coordinator = ProfileSettingCoordinator(navigationController: navigationController)
                return coordinator
                
            default:
                return ProfileSettingCoordinator(navigationController: navigationController)
            }
        }
    }
}
