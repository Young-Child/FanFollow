//
//  AppCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let data = UserDefaults.standard.object(forKey: UserDefaults.Key.session) as? Data,
           let _ = try? JSONDecoder().decode(StoredSession.self, from: data) {
            presentMainView()
            return
        }
        
        presentLogInView()
    }
    
    func presentMainView() {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    func presentLogInView() {
        let coordinator = LogInCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
}
