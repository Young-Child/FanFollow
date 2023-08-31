//
//  SettingCoodinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class SettingCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SettingTabBarController()
        controller.coordinator = self
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentSettingDetailController(to viewType: SettingSectionItem.PresentType) {
        let coordinator = generateCoordinator(to: viewType, with: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func presentPostBottomViewController() {
        let coordinator = UploadCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
    
    func presentEditPostViewController(post: Post) {
        let coordinator = UploadCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        let uploadType: UploadCoordinator.UploadType = (post.videoURL == nil) ? .photo : .link
        coordinator.presentPostViewController(type: uploadType, post: post)
    }
}

private extension SettingCoordinator {
    func generateCoordinator(
        to viewType: SettingSectionItem.PresentType,
        with navigationController: UINavigationController
    ) -> Coordinator {
        switch viewType {
        case .profile:
            let coordinator = ProfileSettingCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            return coordinator
            
        case .bugReport:
            let coordinator = MailCoordinator(
                navigationController: navigationController,
                mailType: .bugReport
            )
            coordinator.parentCoordinator = self
            return coordinator
            
        case .evaluation:
            let coordinator = EvaluateAppCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            return coordinator
            
        case .openSource:
            let coordinator = OpenSourceCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            return coordinator
            
        case .privacy:
            let coordinator = PrivacyCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            return coordinator
            
        case .creator:
            let coordinator = CreatorApplicationCoordinator(
                navigationController: navigationController
            )
            coordinator.parentCoordinator = self
            return coordinator
            
        case .logOut:
            let coordinator = LogOutCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            return coordinator
            
        case .withdrawal:
            let coordinator = WithdrawalCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            return coordinator

        case .blockCreatorManagement:
            let coordinator = BlockCreatorManagementCoordinator(
                navigationController: navigationController
            )
            coordinator.parentCoordinator = self
            return coordinator
        default:
            return ProfileSettingCoordinator(navigationController: navigationController)
        }
    }
}
