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
    weak var parentCoordinator: SettingCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = UploadBottomSheetViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.coordinator = self
        
        navigationController.present(controller, animated: false)
    }
    
    func presentPostViewController(viewController: UIViewController, type: UploadType) {
        let networkService = DefaultNetworkService()
        let repository = DefaultPostRepository(networkService: networkService)
        let imageRepository = DefaultImageRepository(network: networkService)
        
        let useCase = DefaultUploadPostUseCase(postRepository: repository, imageRepository: imageRepository)
        let viewModel = UploadViewModel(uploadUseCase: useCase)
        
        viewController.dismiss(animated: true)
        
        switch type {
        case .photo:
            let controller = UploadPhotoViewController(viewModel: viewModel)
            controller.coordinator = self
            controller.hidesBottomBarWhenPushed = true
            
            navigationController.pushViewController(controller, animated: false)
        default:
            return
        }
    }
    
    func presentImagePickerViewController(cropImageDelegate: UploadCropImageDelegate) {
        let controller = UploadImagePickerViewController()
        controller.uploadCropImageDelegate = cropImageDelegate
        
        let childNavigationController = UINavigationController(rootViewController: controller)
        childNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(childNavigationController, animated: true)
    }
    
    func close(viewController: UIViewController) {
        viewController.dismiss(animated: false)
        parentCoordinator?.removeChildCoordinator(self)
    }
}

extension UploadCoordinator {
    enum UploadType {
        case photo
        case link
    }
}
