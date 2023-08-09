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
        case .explore:      return "탐색"
        case .subscribe:    return "나의 구독"
        }
    }
    
    var viewController: UIViewController {
        let networkManager = DefaultNetworkService.shared
        // TODO: 임시 구현
        let userID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        
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
                followRepository: DefaultFollowRepository(networkManager)
            )
            let viewModel = ExploreSubscribeViewModel(userID: userID, fetchCreatorUseCase: useCase)
            
            return ExploreSubscribeViewController(viewModel: viewModel)
        }
    }
}
