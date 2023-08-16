//
//  SignUpUserUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/11.
//

import Foundation
import RxSwift

protocol SignUpUserUseCase {
    func checkSignUp(userID: String) -> Observable<Bool>
    func signUp(userID: String, nickName: String) -> Completable
}

final class DefaultSignUpUserUseCase: SignUpUserUseCase {
    private let userInformationRepository: UserInformationRepository

    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }

    func checkSignUp(userID: String) -> Observable<Bool> {
        return userInformationRepository.checkSignUpUser(for: userID)
    }

    func signUp(userID: String, nickName: String) -> Completable {
        return userInformationRepository.upsertUserInformation(
            userID: userID,
            nickName: nickName,
            profilePath: nil,
            jobCategory: nil,
            links: nil,
            introduce: nil,
            isCreator: false,
            createdAt: Date()
        )
    }
}
