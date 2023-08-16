//
//  LogOutCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

final class LogOutCoordinator: Coordinator {
    weak var parentCoordinator: SettingCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = DefaultAuthRepository(
            networkService: DefaultNetworkService.shared,
            userDefaultsService: UserDefaults.standard
        )
        let useCase = DefaultLogOutUseCase(authRepository: repository)
        let viewModel = LogOutViewModel(logOutUseCase: useCase)
        
        let controller = LogOutViewController(viewModel: viewModel)
        controller.modalPresentationStyle = .overFullScreen
        controller.coordinator = self
        
        navigationController.present(controller, animated: false)
    }
    
    func close(viewController: UIViewController) {
        viewController.dismiss(animated: false)
        parentCoordinator?.removeChildCoordinator(self)
    }
}
