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
            let fetchCreatorPostUseCase = DefaultFetchCreatorPostsUseCase(
                postRepository: DefaultPostRepository(networkService: DefaultNetworkService())
            )
            let fetchCreatorInformationUseCase = DefaultFetchCreatorInformationUseCase(
                userInformationRepository: DefaultUserInformationRepository(DefaultNetworkService()),
                followRepository: DefaultFollowRepository(DefaultNetworkService())
            )
            let changeLikeUseCase = DefaultChangeLikeUseCase(
                likeRepository: DefaultLikeRepository(networkService: DefaultNetworkService())
            )
            // TODO: 로그인한 UserID를 creatorID에 입력
            let viewModel = FeedManageViewModel(fetchCreatorPostUseCase: fetchCreatorPostUseCase, fetchCreatorInformationUseCase: fetchCreatorInformationUseCase, changeLikeUseCase: changeLikeUseCase, creatorID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2")
            return FeedManageViewController(viewModel: viewModel)
        }
    }
}
