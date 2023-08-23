//
//  ExploreTapItem.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

enum ExploreTabItem: Int, TabItem {
    case explore
    case subscribe
    
    var description: String {
        switch self {
        case .explore:      return Constants.Text.explore
        case .subscribe:    return Constants.Text.mySubscribe
        }
    }
    
    var viewController: UIViewController {
        let networkService = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        
        switch self {
        case .explore:
            let useCase = DefaultFetchExploreUseCase(
                userInformationRepository: DefaultUserInformationRepository(networkService)
            )
            let viewModel = ExploreViewModel(exploreUseCase: useCase)
            
            return ExploreViewController(viewModel: viewModel)
        case .subscribe:
            let useCase = DefaultFetchCreatorInformationUseCase(
                userInformationRepository: DefaultUserInformationRepository(networkService),
                followRepository: DefaultFollowRepository(networkService),
                authRepository: DefaultAuthRepository(
                    networkService: networkService,
                    userDefaultsService: userDefaultsService
                )
            )
            let viewModel = ExploreSubscribeViewModel(fetchCreatorUseCase: useCase)
            
            return ExploreSubscribeViewController(viewModel: viewModel)
        }
    }
}
