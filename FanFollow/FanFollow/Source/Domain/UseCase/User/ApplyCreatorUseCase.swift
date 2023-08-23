//
//  ApplyCreatorUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/31.
//

import RxSwift

protocol ApplyCreatorUseCase {
    func applyCreator(
        creatorInformation: (category: Int?, links: [String]?, introduce: String?)
    ) -> Completable
}

final class DefaultApplyCreatorUseCase: ApplyCreatorUseCase {
    private let userInformationRepository: UserInformationRepository
    private let authRepository: AuthRepository

    init(userInformationRepository: UserInformationRepository, authRepository: AuthRepository) {
        self.userInformationRepository = userInformationRepository
        self.authRepository = authRepository
    }

    func applyCreator(
        creatorInformation: (category: Int?, links: [String]?, introduce: String?)
    ) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .flatMapLatest { userInformation in
                        return self.userInformationRepository.upsertUserInformation(
                            userID: userID,
                            nickName: userInformation.nickName,
                            profilePath: nil,
                            jobCategory: creatorInformation.category,
                            links: creatorInformation.links,
                            introduce: creatorInformation.introduce,
                            isCreator: true,
                            createdAt: userInformation.createdDate)
                        .asObservable()
                    }
            }
            .asCompletable()
    }
}
