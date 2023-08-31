//
//  WithdrawalCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

final class WithdrawalCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let childViewController = RegisterOutViewController()
        let controller = BottomSheetViewController(
            controller: childViewController,
            bottomHeightRatio: 0.4
        )
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController.present(controller, animated: false)
    }
    
    func reconnect(current viewController: UIViewController) {
        let application = UIApplication.shared
        guard let scene = application.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        viewController.dismiss(animated: false) {
            scene.mainCoordinator?.start()
        }
    }
}
