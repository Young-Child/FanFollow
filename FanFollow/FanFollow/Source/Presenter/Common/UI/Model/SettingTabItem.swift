//
//  SettingTabItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

enum SettingTabItem: Int, TabItem {
    case setting
    case feedManage
    
    var description: String {
        switch self {
        case .setting:      return Constants.Text.setting
        case .feedManage:   return Constants.Text.feedManage
        }
    }
    
    var viewController: UIViewController {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        
        switch self {
        case .setting:
            let useCase = DefaultFetchUserInformationUseCase(
                userInformationRepository: DefaultUserInformationRepository(networkService),
                authRepository: DefaultAuthRepository(
                    networkService: networkService,
                    userDefaultsService: userDefaultsService
                )
            )
            let viewModel = SettingViewModel(userInformationUseCase: useCase)
            return SettingViewController(viewModel: viewModel)
        case .feedManage:
            let postRepository = DefaultPostRepository(networkService)
            let imageRepository = DefaultImageRepository(networkService)
            let authRepository = DefaultAuthRepository(
                networkService: networkService,
                userDefaultsService: userDefaultsService
            )
            
            let fetchCreatorPostsUseCase = DefaultFetchCreatorPostsUseCase(
                postRepository: postRepository,
                imageRepository: imageRepository,
                authRepository: authRepository
            )

            let userInformationRepository = DefaultUserInformationRepository(networkService)
            let followRepository = DefaultFollowRepository(networkService)
            let fetchCreatorInformationUseCase = DefaultFetchCreatorInformationUseCase(
                userInformationRepository: userInformationRepository,
                followRepository: followRepository,
                authRepository: authRepository
            )

            let likeRepository = DefaultLikeRepository(networkService)
            let changeLikeUseCase = DefaultChangeLikeUseCase(
                likeRepository: likeRepository,
                authRepository: authRepository
            )

            let profileFeedViewModel = ProfileFeedViewModel(
                fetchCreatorPostUseCase: fetchCreatorPostsUseCase,
                fetchCreatorInformationUseCase: fetchCreatorInformationUseCase,
                changeLikeUseCase: changeLikeUseCase,
                creatorID: nil
            )
            
            let profileViewController = ProfileFeedViewController(
                viewModel: profileFeedViewModel,
                viewType: .feedManage
            )

            return profileViewController
        }
    }
}
