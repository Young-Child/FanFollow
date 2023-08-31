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

    func presentUserDeclaration(_ banUserID: String?) {
        guard let banUserID = banUserID else { return }
        
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        let reportRepository = DefaultReportRepository(networkService: networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )
        
        let useCase = DefaultSendUserReportUseCase(
            reportRepository: reportRepository,
            authRepository: authRepository
        )
        
        let viewModel = ReportViewModel(sendReportUseCase: useCase, banID: banUserID)
        
        let childViewController = ReportViewController(viewModel: viewModel, reportType: .content)
        childViewController.coordinator = self
        
        let controller = BottomSheetViewController(
            controller: childViewController,
            bottomHeightRatio: 0.6
        )
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController.present(controller, animated: false)
    }
    
    func presentPostDeclaration(_ banPostID: String?) {
        guard let banPostID = banPostID else { return }
        
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
        
        let controller = BottomSheetViewController(
            controller: childViewController,
            bottomHeightRatio: 0.6
        )
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController.present(controller, animated: false)
    }
    
    func presentUserBlockBottomView() {
        let networkService = DefaultNetworkService.shared
        
        let blockUserRepository = DefaultBlockUserRepository(networkService: networkService)
        let informationRepository = DefaultUserInformationRepository(networkService)
        let followRepository = DefaultFollowRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: UserDefaults.standard
        )
        
        let manageBlockUserUseCase = DefaultManageBlockCreatorUseCase(
            blockCreatorUseCase: blockUserRepository,
            userInformationRepository: informationRepository,
            followRepository: followRepository,
            authRepository: authRepository
        )
        
        let viewModel = BlockUserViewModel(
            userID: self.creatorID,
            manageBlockUserUseCase: manageBlockUserUseCase
        )
        let controller = BlockUserViewController(viewModel: viewModel)
        controller.coordinator = self
        let bottomController = BottomSheetViewController(
            controller: controller,
            bottomHeightRatio: 0.3
        )
        bottomController.modalTransitionStyle = .crossDissolve
        bottomController.modalPresentationStyle = .overFullScreen
        
        navigationController.present(bottomController, animated: true)
    }
}
