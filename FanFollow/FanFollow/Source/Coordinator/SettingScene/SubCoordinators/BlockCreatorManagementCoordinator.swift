//
//  BlockCreatorManagementCoordinator.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import UIKit

final class BlockCreatorManagementCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        let blockUserRepository = DefaultBlockUserRepository(networkService: networkService)
        let userInformationRepository = DefaultUserInformationRepository(networkService)
        let followRepository = DefaultFollowRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )
        let manageBlockCreatorUseCase = DefaultManageBlockCreatorUseCase(
            blockCreatorUseCase: blockUserRepository,
            userInformationRepository: userInformationRepository,
            followRepository: followRepository,
            authRepository: authRepository
        )

        let blockCreatorManagementViewModel = BlockCreatorManagementViewModel(
            manageBlockCreatorUseCase: manageBlockCreatorUseCase
        )

        let blockCreatorManagementViewController = BlockCreatorManagementViewController(
            viewModel: blockCreatorManagementViewModel
        )
        blockCreatorManagementViewController.coordinator = self
        blockCreatorManagementViewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(
            blockCreatorManagementViewController,
            animated: true
        )
    }
}
