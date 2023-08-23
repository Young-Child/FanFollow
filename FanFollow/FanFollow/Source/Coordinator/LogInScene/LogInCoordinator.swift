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
        let networkService = DefaultNetworkService.shared
        let userInformationRepository = DefaultUserInformationRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: DefaultNetworkService.shared,
            userDefaultsService: UserDefaults.standard
        )
        
        let appleSignUseCase = DefaultAppleSigningUseCase(authRepository: authRepository)
        let signUseCase = DefaultSignUpUserUseCase(
            userInformationRepository: userInformationRepository,
            authRepository: authRepository
        )
        
        let viewModel = LogInViewModel(
            appleSignUseCase: appleSignUseCase,
            signUpUserUseCase: signUseCase
        )
        let controller = LogInViewController(viewModel: viewModel)
        
        controller.coordinator = self
        
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func didSuccessLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.presentMainView()
    }
}
