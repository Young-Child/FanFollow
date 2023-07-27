//
//  ExploreCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/27.
//

import UIKit

class ExploreCoordinator: Coordinator {
    weak var parentCoordinator: MainTabBarCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let userInformationRepository: UserInformationRepository
    private let exploreUseCase: ExploreUseCase
    private let searchUseCase: SearchCreatorUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService())
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
        
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentProfileViewController() {
        
    }
    
    func presentSearchViewController() {
        let viewModel = ExploreSearchViewModel(searchCreatorUseCase: searchUseCase)
        let controller = ExploreSearchViewController(viewModel: viewModel)
        
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
