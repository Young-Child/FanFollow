//
//  EvaluateAppCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class EvaluateAppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let url = URL(string: Constants.appStoreURL) else { return }
        
        UIApplication.shared.open(url)
    }
}

private extension EvaluateAppCoordinator {
    enum Constants {
        static let appStoreURL: String = "itms-apps://itunes.apple.com/app/6450774849"
    }
}
