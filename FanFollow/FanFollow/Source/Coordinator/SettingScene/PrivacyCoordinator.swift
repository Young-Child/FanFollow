//
//  PrivacyCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/17.
//

import SafariServices
import UIKit

final class PrivacyCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let url = URL(string: Constants.Text.privacyInformationURL) {
            UIApplication.shared.open(url)
        }
    }
}
