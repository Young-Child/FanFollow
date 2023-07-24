//
//  UpdateUserInformationUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol UpdateUserInformationUseCase: AnyObject {
    func updateUserInformation(
        userID: String,
        updateInformation: (nickName: String?, category: Int?, links: [String]?, introduce: String?)
    ) -> Observable<Void>
}

final class DefaultUpdateUserInformationUseCase: UpdateUserInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    
    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }
    
    func updateUserInformation(
        userID: String,
        updateInformation: (nickName: String?, category: Int?, links: [String]?, introduce: String?)
    ) -> Observable<Void> {
        return userInformationRepository.fetchUserInformation(for: userID)
            .flatMapLatest { information in
                return self.userInformationRepository.upsertUserInformation(
                    userID: userID,
                    nickName: updateInformation.nickName ?? information.nickName,
                    profilePath: nil,
                    jobCategory: updateInformation.category ?? information.jobCategory,
                    links: updateInformation.links ?? information.links,
                    introduce: updateInformation.introduce ?? information.introduce,
                    isCreator: information.isCreator,
                    createdAt: information.createdAt
                )
                .andThen(Observable<Void>.just(()))
            }
            .debug()
            .asObservable()
    }
}
