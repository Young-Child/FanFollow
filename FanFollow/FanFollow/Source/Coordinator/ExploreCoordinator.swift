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
    private let exploreUseCase: ExploreUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let userInformationRepository = DefaultUserInformationRepository(DefaultNetworkService())
        exploreUseCase = DefaultExploreUseCase(userInformationRepository: userInformationRepository)
    }
    
    func start() {
        let controller = ExploreTabBarController()
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentCategoryViewController(for jobCategory: JobCategory) {
        let viewModel = ExploreCategoryViewModel(exploreUseCase: exploreUseCase, jobCategory: jobCategory)
        let controller = ExploreCategoryViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentProfileViewController() {
        
    }
}
