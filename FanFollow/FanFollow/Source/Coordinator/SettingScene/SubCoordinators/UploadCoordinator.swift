//
//  UploadCoordinator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import UIKit

final class UploadCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
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
    
    func presentPostViewController(
        type: UploadType,
        post: Post? = nil
    ) {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        
        let postRepository = DefaultPostRepository(networkService)
        let imageRepository = DefaultImageRepository(networkService)
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            userDefaultsService: userDefaultsService
        )
        
        let useCase = DefaultUploadPostUseCase(
            postRepository: postRepository,
            imageRepository: imageRepository,
            authRepository: authRepository
        )
        let viewModel = UploadViewModel(uploadUseCase: useCase, post: post)
        
        let controller = generateInstance(with: viewModel, uploadType: type)
        
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func presentImagePickerViewController(cropImageDelegate: UploadCropImageDelegate) {
        let controller = UploadImagePickerViewController()
        controller.uploadCropImageDelegate = cropImageDelegate
        
        let childNavigationController = UINavigationController(rootViewController: controller)
        childNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(childNavigationController, animated: true)
    }
}

extension UploadCoordinator {
    enum UploadType {
        case photo
        case link
    }
    
    func generateInstance(
        with viewModel: UploadViewModel,
        uploadType: UploadType
    ) -> UIViewController {
        switch uploadType {
        case .photo:
            let controller = UploadPhotoViewController(viewModel: viewModel)
            controller.hidesBottomBarWhenPushed = true
            controller.coordinator = self
            
            return controller
            
        case .link:
            let controller = UploadLinkViewController(viewModel: viewModel)
            controller.hidesBottomBarWhenPushed = true
            controller.coordinator = self
            
            return controller
        }
    }
}
