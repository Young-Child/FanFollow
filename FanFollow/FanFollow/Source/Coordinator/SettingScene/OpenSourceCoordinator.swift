//
//  OpenSourceCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class OpenSourceCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
