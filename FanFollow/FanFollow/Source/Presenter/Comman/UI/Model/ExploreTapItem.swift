//
//  ExploreTapItem.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

enum ExploreTapItem: Int, TabItem {
    case explore
    case subscribe
    
    var description: String {
        switch self {
        case .explore:      return Constants.Text.explore
        case .subscribe:    return Constants.Text.mySubscribe
        }
    }
    
    var viewController: UIViewController {
        let networkManager = DefaultNetworkService.shared
        let userDefaultsService = UserDefaults.standard
        
        switch self {
        case .explore:
            let useCase = DefaultExploreUseCase(
                userInformationRepository: DefaultUserInformationRepository(networkManager)
            )
            let viewModel = ExploreViewModel(exploreUseCase: useCase)
            
            return ExploreViewController(viewModel: viewModel)
        case .subscribe:
            let useCase = DefaultFetchCreatorInformationUseCase(
                userInformationRepository: DefaultUserInformationRepository(networkManager),
                followRepository: DefaultFollowRepository(networkManager),
                authRepository: DefaultAuthRepository(
                    networkService: networkManager,
                    userDefaultsService: userDefaultsService
                )
            )
            let viewModel = ExploreSubscribeViewModel(fetchCreatorUseCase: useCase)
            
            return ExploreSubscribeViewController(viewModel: viewModel)
        }
    }
}
