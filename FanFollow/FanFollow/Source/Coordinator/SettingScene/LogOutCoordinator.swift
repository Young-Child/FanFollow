//
//  LogOutCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

final class LogOutCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
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
    
    func reconnect(current viewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        viewController.dismiss(animated: false) {
            scene.mainCoordinator?.start()
        }
    }
}
