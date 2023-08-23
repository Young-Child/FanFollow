//
//  CreatorApplicationCoordinator.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/01.
//

import UIKit

final class CreatorApplicationCoordinator: Coordinator {
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
        let userInformationUpdateRepository = DefaultUpdateUserInformationUseCase(
            userInformationRepository: userInformationRepository,
            authRepository: authRepository
        )
        
        let creatorApplicationViewModel = CreatorApplicationViewModel(
            informationUseCase: userInformationUpdateRepository
        )
        let creatorApplicationViewController = CreatorApplicationViewController(viewModel: creatorApplicationViewModel)
        creatorApplicationViewController.coordinator = self
        creatorApplicationViewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(creatorApplicationViewController, animated: true)
    }
}
