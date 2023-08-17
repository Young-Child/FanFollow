//
//  SignUpUserUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/11.
//

import Foundation
import RxSwift

protocol SignUpUserUseCase {
    func checkSignUp() -> Observable<Bool>
    func signUp(nickName: String) -> Completable
}

final class DefaultSignUpUserUseCase: SignUpUserUseCase {
    private let userInformationRepository: UserInformationRepository
    private let authRepository: AuthRepository

    init(userInformationRepository: UserInformationRepository, authRepository: AuthRepository) {
        self.userInformationRepository = userInformationRepository
        self.authRepository = authRepository
    }

    func checkSignUp() -> Observable<Bool> {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.userInformationRepository.checkSignUpUser(for: userID)
            }
    }

    func signUp(nickName: String) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.userInformationRepository.upsertUserInformation(
                    userID: userID,
                    nickName: nickName,
                    profilePath: nil,
                    jobCategory: nil,
                    links: nil,
                    introduce: nil,
                    isCreator: false,
                    createdAt: Date()
                )
                .asObservable()
            }
            .asCompletable()
    }
}
