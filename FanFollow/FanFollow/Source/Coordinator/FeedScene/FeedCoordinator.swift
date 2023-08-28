//
//  FeedCoordinator.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/27.
//

import UIKit
import SafariServices

final class FeedCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        let postRepository = DefaultPostRepository(networkService)
        let imageRepository = DefaultImageRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )
        let likeRepository = DefaultLikeRepository(networkService)

        let fetchFeedUseCase = DefaultFetchFeedUseCase(
            postRepository: postRepository,
            imageRepository: imageRepository,
            authRepository: authRepository
        )
        let changeLikeUseCase = DefaultChangeLikeUseCase(
            likeRepository: likeRepository,
            authRepository: authRepository
        )

        let feedViewModel = FeedViewModel(
            fetchFeedUseCase: fetchFeedUseCase,
            changeLikeUseCase: changeLikeUseCase
        )
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.coordinator = self

        navigationController.pushViewController(feedViewController, animated: true)
    }

    func presentProfileViewController(creatorID: String) {
        let coordinator = ProfileFeedCoordinator(
            navigationController: navigationController,
            creatorID: creatorID
        )
        
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
    
    func presentLinkViewController(to presentURL: URL) {
        let controller = SFSafariViewController(url: presentURL)
        controller.dismissButtonStyle = .close
        controller.hidesBottomBarWhenPushed = true
        navigationController.present(controller, animated: true)
    }
    
    func presentDeclaration(_ postID: String?) {
        guard let postID = postID else { return }
        let mailCoordinator = MailCoordinator(
            navigationController: navigationController,
            mailType: .declaration(postID: postID, isUser: false)
        )
        childCoordinators.append(mailCoordinator)
        
        mailCoordinator.start()
    }
}
