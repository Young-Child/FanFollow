//
//  FetchUserInformationUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/13.
//

import RxSwift

protocol FetchUserInformationUseCase: AnyObject {
    func fetchUserInformation() -> Observable<User>
    func fetchCreatorInformation() -> Observable<Creator>
}

final class DefaultFetchUserInformationUseCase: FetchUserInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    private let authRepository: AuthRepository

    init(userInformationRepository: UserInformationRepository, authRepository: AuthRepository) {
        self.userInformationRepository = userInformationRepository
        self.authRepository = authRepository
    }

    func fetchUserInformation() -> Observable<User> {
        return authRepository.storedSession()
            .flatMap { storedSession -> Observable<User> in
                let userID = storedSession.userID
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .compactMap { userInformationDTO in
                        if userInformationDTO.isCreator {
                            return Creator(userInformationDTO)
                        } else {
                            return Fan(userInformationDTO)
                        }
                    }
            }
    }
    
    func fetchCreatorInformation() -> Observable<Creator> {
        return authRepository.storedSession()
            .flatMap { storedSession -> Observable<Creator> in
                let userID = storedSession.userID
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .map { Creator($0) }
            }
    }
}
