//
//  UploadCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import UIKit

final class UploadCoordinator: Coordinator {
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
    func presentPostViewController(
        type: UploadType,
        viewController: UIViewController? = nil,
        post: Post? = nil
    ) {
        let networkService = DefaultNetworkService.shared
        
        let repository = DefaultPostRepository(networkService)
        let imageRepository = DefaultImageRepository(networkService)
        
        let useCase = DefaultUploadPostUseCase(postRepository: repository, imageRepository: imageRepository)
        let viewModel = UploadViewModel(uploadUseCase: useCase, post: post)
        
        let controller = type.generateInstance(with: viewModel, coordinator: self)
        
        func presentController() {
            self.navigationController.pushViewController(controller, animated: true)
        }
        
        if viewController != nil {
            viewController?.dismiss(animated: true) { presentController() }
        } else {
            presentController()
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
        
        func generateInstance(with viewModel: UploadViewModel, coordinator: UploadCoordinator) -> UIViewController {
            switch self {
            case .photo:
                let controller = UploadPhotoViewController(viewModel: viewModel)
                controller.hidesBottomBarWhenPushed = true
                controller.coordinator = coordinator
                
                return controller
                
            case .link:
                let controller = UploadLinkViewController(viewModel: viewModel)
                controller.hidesBottomBarWhenPushed = true
                controller.coordinator = coordinator
                
                return controller
            }
        }
    }
}
