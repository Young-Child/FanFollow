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
        switch self {
        case .explore:
            let useCase = DefaultExploreUseCase(
                userInformationRepository: DefaultUserInformationRepository(
                    DefaultNetworkService(
                        session: URLSession.shared
                    )
                )
            )
            let viewModel = ExploreViewModel(exploreUseCase: useCase)
            return ExploreViewController(viewModel: viewModel)
        case .subscribe: return UIViewController()
        }
    }
}
