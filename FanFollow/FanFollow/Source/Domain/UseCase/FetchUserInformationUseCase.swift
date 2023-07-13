//
//  FetchUserInformationUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/13.
//

import RxSwift

protocol FetchUserInformationUseCase: AnyObject {
    func fetchUserInformation(for userID: String) -> Observable<User>
}

final class DefaultFetchUserInformationUseCase: FetchUserInformationUseCase {
    private let userInformationRepository: UserInformationRepository

    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }

    func fetchUserInformation(for userID: String) -> Observable<User> {
        return userInformationRepository.fetchUserInformation(for: userID)
            .compactMap { userInformationDTO in
                if userInformationDTO.isCreator {
                    return Creator(userInformationDTO)
                } else {
                    return Fan(userInformationDTO)
                }
            }
    }
}
