//
//  LogInCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/10.
//

import UIKit

final class LogInCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = LogInViewController()
        controller.coordinator = self
        
        navigationController.setViewControllers([controller], animated: true)
    }
}
