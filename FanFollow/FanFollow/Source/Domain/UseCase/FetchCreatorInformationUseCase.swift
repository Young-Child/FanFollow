//
//  FetchCreatorInformationUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol FetchCreatorInformationUseCase: AnyObject {
    func fetchCreatorInformation(for creatorID: String) -> Observable<Creator>
}

final class DefaultFetchCreatorInformationUseCase: FetchCreatorInformationUseCase {
    private let userInformationRepository: UserInformationRepository

    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }

    func fetchCreatorInformation(for creatorID: String) -> Observable<Creator> {
        return userInformationRepository.fetchUserInformation(for: creatorID)
            .compactMap { userInformationDTO in
                return Creator(userInformationDTO)
            }
    }
}
