//
//  LogInCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/10.
//

import UIKit

final class LogInCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = DefaultAuthRepository(
            networkService: DefaultNetworkService.shared,
            userDefaultsService: UserDefaults.standard
        )
        let signUseCase = DefaultAppleSigningUseCase(authRepository: repository)
        let viewModel = LogInViewModel(signUseCase: signUseCase)
        let controller = LogInViewController(viewModel: viewModel)
        
        controller.coordinator = self
        
        navigationController.setViewControllers([controller], animated: true)
    }
}
