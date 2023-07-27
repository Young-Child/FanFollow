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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService())
    }
    
    func start() {
        let controller = ExploreTabBarController()
        controller.coordinator = self
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentCategoryViewController(for jobCategory: JobCategory) {
        let exploreUseCase = DefaultExploreUseCase(userInformationRepository: userInformationRepository)
        let viewModel = ExploreCategoryViewModel(exploreUseCase: exploreUseCase, jobCategory: jobCategory)
        let controller = ExploreCategoryViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentProfileViewController() {
        
    }
    
    func presentSearchViewController() {
        let searchUseCase = DefaultSearchCreatorUseCase(userInformationRepository: userInformationRepository)
        let viewModel = ExploreSearchViewModel(searchCreatorUseCase: searchUseCase)
        let controller = ExploreSearchViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: true)
    }
}
