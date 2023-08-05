//
//  FeedCoordinator.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/27.
//

import UIKit
import SafariServices

final class FeedCoordinator: Coordinator {
    weak var parentCoordinator: MainTabBarCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // TODO: 로그인한 UserID를 followerID에 입력
        let userID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        presentFeedViewController(userID: userID)
    }

    func presentFeedViewController(userID: String) {
        let session = URLSession.shared
        let networkService = DefaultNetworkService(session: session)

        let postRepository = DefaultPostRepository(networkService: networkService)
        let fetchFeedUseCase = DefaultFetchFeedUseCase(postRepository: postRepository)

        let likeRepository = DefaultLikeRepository(networkService: networkService)
        let changeLikeUseCase = DefaultChangeLikeUseCase(likeRepository: likeRepository)

        let feedViewModel = FeedViewModel(
            fetchFeedUseCase: fetchFeedUseCase,
            changeLikeUseCase: changeLikeUseCase,
            followerID: userID
        )
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.coordinator = self
        feedViewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(feedViewController, animated: true)
    }

    func presentProfileViewController(creatorID: String, userID: String) {
        let session = URLSession.shared
        let networkService = DefaultNetworkService(session: session)

        let postRepository = DefaultPostRepository(networkService: networkService)
        let imageRepository = DefaultImageRepository(network: networkService)
        let fetchCreatorPostsUseCase = DefaultFetchCreatorPostsUseCase(
            postRepository: postRepository,
            imageRepository: imageRepository
        )

        let userInformationRepository = DefaultUserInformationRepository(networkService)
        let followRepository = DefaultFollowRepository(networkService)
        let fetchCreatorInformationUseCase = DefaultFetchCreatorInformationUseCase(
            userInformationRepository: userInformationRepository,
            followRepository: followRepository
        )

        let likeRepository = DefaultLikeRepository(networkService: networkService)
        let changeLikeUseCase = DefaultChangeLikeUseCase(likeRepository: likeRepository)

        let profileFeedViewModel = ProfileFeedViewModel(
            fetchCreatorPostUseCase: fetchCreatorPostsUseCase,
            fetchCreatorInformationUseCase: fetchCreatorInformationUseCase,
            changeLikeUseCase: changeLikeUseCase,
            creatorID: creatorID,
            userID: userID
        )
        let profileViewController = ProfileFeedViewController(viewModel: profileFeedViewModel, viewType: .profileFeed)

        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func presentLinkViewController(to presentURL: URL) {
        let controller = SFSafariViewController(url: presentURL)
        controller.dismissButtonStyle = .close
        controller.hidesBottomBarWhenPushed = true
        
        navigationController.present(controller, animated: true)
    }
}
