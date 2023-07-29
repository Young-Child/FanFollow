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
    
    func presentSettingViewController() {
        let userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService())
        let fetchUserInformation = DefaultFetchUserInformationUseCase(
            userInformationRepository: userInformationRepository
        )
        let updateUserInformation = DefaultUpdateUserInformationUseCase(
            userInformationRepository: userInformationRepository
        )
        let viewModel = ProfileSettingViewModel(
            userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
            fetchUseCase: fetchUserInformation,
            updateUseCase: updateUserInformation
        )
        let controller = ProfileSettingViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: true)
    }
}
