//
//  ProfileSettingCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProfileSettingCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        let userInformationRepository = DefaultUserInformationRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )
        let fetchUseCase = DefaultFetchUserInformationUseCase(
            userInformationRepository: userInformationRepository,
            authRepository: authRepository
        )
        let updateUseCase = DefaultUpdateUserInformationUseCase(
            userInformationRepository: userInformationRepository,
            authRepository: authRepository
        )
        
        let profileSettingViewModel = ProfileSettingViewModel(
            fetchUseCase: fetchUseCase,
            updateUseCase: updateUseCase
        )
        let controller = ProfileSettingViewController(viewModel: profileSettingViewModel)
        controller.coordinator = self
        controller.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentSelectImagePickerViewController() {
        let coordinator = ProfileImagePickerCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
