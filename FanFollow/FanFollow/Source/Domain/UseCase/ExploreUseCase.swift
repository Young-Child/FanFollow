//
//  ExploreUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation

protocol ExploreUseCase: AnyObject {
    
}

final class DefaultExploreUseCase: ExploreUseCase {
    private let useInformationRepository: UserInformationRepository
    
    init(useInformationRepository: UserInformationRepository) {
        self.useInformationRepository = useInformationRepository
    }
}
