//
//  ProfileImagePickerCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProfileImagePickerCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        let profileImageUploadUseCase = DefaultUpdateProfileImageUseCase(
            imageRepository: DefaultImageRepository(networkService),
            authRepository: DefaultAuthRepository(
                networkService: networkService,
                userDefaultsService: userDefaultsService
            )
        )
        
        let viewModel = ProfileImagePickerViewModel(
            profileImageUploadUseCase: profileImageUploadUseCase
        )
        
        let controller = ProfileImagePickerViewController(viewModel: viewModel)
        controller.coordinator = self
        let childNavigationController = UINavigationController(rootViewController: controller)
        childNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(childNavigationController, animated: true)
    }
}
