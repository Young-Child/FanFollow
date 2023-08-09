//
//  CreatorApplicationCoordinator.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/01.
//

import UIKit

final class CreatorApplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService.shared)
        let applyCreatorUseCase = DefaultApplyCreatorUseCase(userInformationRepository: userInformationRepository)
        // TODO: 로그인한 UserID를 입력
        let userID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        let creatorApplicationViewModel = CreatorApplicationViewModel(
            applyCreatorUseCase: applyCreatorUseCase,
            userID: userID
        )
        let creatorApplicationViewController = CreatorApplicationViewController(viewModel: creatorApplicationViewModel)
        creatorApplicationViewController.coordinator = self

        navigationController.pushViewController(creatorApplicationViewController, animated: true)
    }
}
