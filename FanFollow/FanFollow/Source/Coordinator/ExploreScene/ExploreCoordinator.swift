//
//  ExploreCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/27.
//

import UIKit

final class ExploreCoordinator: Coordinator {
    // Coordinator Propertiese
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // Dependency
    private let userInformationRepository: UserInformationRepository
    private let exploreUseCase: ExploreUseCase
    private let searchUseCase: SearchCreatorUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService.shared)
        exploreUseCase = DefaultExploreUseCase(userInformationRepository: userInformationRepository)
        searchUseCase = DefaultSearchCreatorUseCase(userInformationRepository: userInformationRepository)
    }
    
    func start() {
        let controller = ExploreTabBarController()
        controller.coordinator = self
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentCategoryViewController(for jobCategory: JobCategory) {
        let viewModel = ExploreCategoryViewModel(exploreUseCase: exploreUseCase, jobCategory: jobCategory)
        let controller = ExploreCategoryViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true

        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentProfileViewController(to creatorID: String) {
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
        let changeLikeUseCase = DefaultChangeLikeUseCase(likeRepository: likeRepository, authRepository: authRepository)

        let viewModel = ProfileFeedViewModel(
            fetchCreatorPostUseCase: fetchCreatorPostsUseCase,
            fetchCreatorInformationUseCase: fetchCreatorInformationUseCase,
            changeLikeUseCase: changeLikeUseCase,
            creatorID: creatorID
        )
        
        let controller = ProfileFeedViewController(viewModel: viewModel, viewType: .profileFeed)
        controller.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentSearchViewController() {
        let viewModel = ExploreSearchViewModel(searchCreatorUseCase: searchUseCase)
        let controller = ExploreSearchViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
