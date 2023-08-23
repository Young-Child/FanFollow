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
        let profileFeedCoordinator = ProfileFeedCoordinator(
            navigationController: navigationController,
            creatorID: creatorID
        )
        self.childCoordinators.append(profileFeedCoordinator)
        profileFeedCoordinator.start()
    }
    
    func presentSearchViewController() {
        let viewModel = ExploreSearchViewModel(searchCreatorUseCase: searchUseCase)
        let controller = ExploreSearchViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
