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
        let userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService.shared)
        let fetchUseCase = DefaultFetchUserInformationUseCase(
            userInformationRepository: userInformationRepository
        )
        let updateUseCase = DefaultUpdateUserInformationUseCase(
            userInformationRepository: userInformationRepository
        )
        
        let profileSettingViewModel = ProfileSettingViewModel(
            userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
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
