//
//  ProfileFeedCoordinator.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/23.
//

import UIKit

final class ProfileFeedCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let creatorID: String

    init(navigationController: UINavigationController, creatorID: String) {
        self.navigationController = navigationController
        self.creatorID = creatorID
    }

    func start() {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard

        let postRepository = DefaultPostRepository(networkService)
        let userInformationRepository = DefaultUserInformationRepository(networkService)
        let followRepository = DefaultFollowRepository(networkService)
        let likeRepository = DefaultLikeRepository(networkService)
        let imageRepository = DefaultImageRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )

        let fetchCreatorPostsUseCase = DefaultFetchCreatorPostsUseCase(
            postRepository: postRepository,
            imageRepository: imageRepository,
            authRepository: authRepository
        )
        let fetchCreatorInformationUseCase = DefaultFetchCreatorInformationUseCase(
            userInformationRepository: userInformationRepository,
            followRepository: followRepository,
            authRepository: authRepository
        )
        let changeLikeUseCase = DefaultChangeLikeUseCase(
            likeRepository: likeRepository,
            authRepository: authRepository
        )

        let viewModel = ProfileFeedViewModel(
            fetchCreatorPostUseCase: fetchCreatorPostsUseCase,
            fetchCreatorInformationUseCase: fetchCreatorInformationUseCase,
            changeLikeUseCase: changeLikeUseCase,
            creatorID: creatorID
        )

        let controller = ProfileFeedViewController(viewModel: viewModel, viewType: .profileFeed)
        controller.coordinator = self
        controller.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(controller, animated: true)
    }

    func presentDeclaration(_ banID: String?, isContent: Bool = true) {
        guard let banID = banID else { return }
        
        let childViewController = ReportViewController(reportType: .content)
        let controller = BottomSheetViewController(controller: childViewController, bottomHeightRatio: 0.6)
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController.present(controller, animated: false)
    }
}
