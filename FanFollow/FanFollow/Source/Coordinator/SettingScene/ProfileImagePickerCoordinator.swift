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
        let profileImageUploadUseCase = DefaultUpdateProfileImageUseCase(
            imageRepository: DefaultImageRepository(DefaultNetworkService.shared)
        )
        
        let viewModel = ProfileImagePickerViewModel(
            userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
            profileImageUploadUseCase: profileImageUploadUseCase
        )
        
        let controller = ProfileImagePickerViewController(viewModel: viewModel)
        let childNavigationController = UINavigationController(rootViewController: controller)
        childNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(childNavigationController, animated: true)
    }
}
