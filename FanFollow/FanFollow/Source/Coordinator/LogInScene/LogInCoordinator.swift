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
        let userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService.shared)
        let authRepository = DefaultAuthRepository(
            networkService: DefaultNetworkService.shared,
            userDefaultsService: UserDefaults.standard
        )
        
        let applesignUseCase = DefaultAppleSigningUseCase(authRepository: authRepository)
        let signUseCase = DefaultSignUpUserUseCase(
            userInformationRepository: userInformationRepository,
            authRepository: authRepository
        )
        
        let viewModel = LogInViewModel(appleSignUseCase: applesignUseCase, signUpUserUseCase: signUseCase)
        let controller = LogInViewController(viewModel: viewModel)
        
        controller.coordinator = self
        
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func didSuccessLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.presentMainView()
    }
}
