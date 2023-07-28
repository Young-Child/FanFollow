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
        case .setting:      return "설정"
        case .feedManage:   return "피드 관리"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .setting:
            let useCase = DefaultFetchUserInformationUseCase(
                userInformationRepository: DefaultUserInformationRepository(
                    DefaultNetworkService(
                        session: URLSession.shared
                    )
                )
            )
            let viewModel = SettingViewModel(userInformationUseCase: useCase)
            return SettingViewController(viewModel: viewModel)
        case .feedManage:
            let session = URLSession.shared
            let networkService = DefaultNetworkService(session: session)

            let postRepository = DefaultPostRepository(networkService: networkService)
            let fetchCreatorPostsUseCase = DefaultFetchCreatorPostsUseCase(postRepository: postRepository)

            let userInformationRepository = DefaultUserInformationRepository(networkService)
            let followRepository = DefaultFollowRepository(networkService)
            let fetchCreatorInformationUseCase = DefaultFetchCreatorInformationUseCase(
                userInformationRepository: userInformationRepository,
                followRepository: followRepository
            )

            let likeRepository = DefaultLikeRepository(networkService: networkService)
            let changeLikeUseCase = DefaultChangeLikeUseCase(likeRepository: likeRepository)

            // TODO: 로그인한 creatorID 입력
            let creatorID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
            let profileFeedViewModel = ProfileFeedViewModel(
                fetchCreatorPostUseCase: fetchCreatorPostsUseCase,
                fetchCreatorInformationUseCase: fetchCreatorInformationUseCase,
                changeLikeUseCase: changeLikeUseCase,
                creatorID: creatorID,
                userID: creatorID
            )
            let profileViewController = ProfileFeedViewController(
                viewModel: profileFeedViewModel,
                viewType: .feedManage
            )

            return profileViewController
        }
    }
}
