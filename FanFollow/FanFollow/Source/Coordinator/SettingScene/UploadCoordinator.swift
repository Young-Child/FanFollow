//
//  UploadCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import UIKit

class UploadCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = UploadBottomSheetViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.coordinator = self
        
        navigationController.present(controller, animated: false)
    }
    
    func presentPostViewControlelr(type: UploadType) {
        // TODO: - 추후 구현
    }
}

extension UploadCoordinator {
    enum UploadType {
        case photo
        case link
    }
}
