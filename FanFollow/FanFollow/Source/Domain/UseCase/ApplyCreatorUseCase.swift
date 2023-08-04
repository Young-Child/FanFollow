//
//  ApplyCreatorUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/31.
//

import RxSwift

protocol ApplyCreatorUseCase {
    func applyCreator(
        userID: String,
        creatorInformation: (category: Int?, links: [String]?, introduce: String?)
    ) -> Completable
}

final class DefaultApplyCreatorUseCase: ApplyCreatorUseCase {
    private let userInformationRepository: UserInformationRepository

    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }

    func applyCreator(
        userID: String,
        creatorInformation: (category: Int?, links: [String]?, introduce: String?)
    ) -> Completable {
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
            .asCompletable()
    }
}
