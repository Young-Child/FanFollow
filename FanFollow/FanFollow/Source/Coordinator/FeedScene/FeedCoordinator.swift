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
    
    func presentDeclaration(_ banPostID: String?) {
        guard let banPostID = banPostID,
              let topViewController = navigationController.topViewController as? FeedViewController
        else { return }
        
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        let reportRepository = DefaultReportRepository(networkService: networkService)
        let blockRepository = DefaultBlockContentRepository(networkService: networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )
        
        let useCase = DefaultSendContentReportUseCase(
            reportRepository: reportRepository,
            blockContentRepository: blockRepository,
            authRepository: authRepository
        )
        
        let viewModel = ReportViewModel(sendReportUseCase: useCase, banID: banPostID)
        let childViewController = ReportViewController(viewModel: viewModel, reportType: .content)
        childViewController.coordinator = self
        childViewController.delegate = topViewController
        let controller = BottomSheetViewController(
            controller: childViewController,
            bottomHeightRatio: 0.6
        )
        
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController.present(controller, animated: false)
    }
}
