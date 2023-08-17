//
//  UpdateUserInformationUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol UpdateUserInformationUseCase: AnyObject {
    func updateUserInformation(
        updateInformation: (nickName: String?, category: Int?, links: [String]?, introduce: String?)
    ) -> Observable<Void>
    
    func updateUserInformation(
        updateInformation: (jobCategory: Int, links: [String], introduce: String)
    ) -> Observable<Void>
}

final class DefaultUpdateUserInformationUseCase: UpdateUserInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    private let authRepository: AuthRepository
    
    init(userInformationRepository: UserInformationRepository, authRepository: AuthRepository) {
        self.userInformationRepository = userInformationRepository
        self.authRepository = authRepository
    }
    
    func updateUserInformation(
        updateInformation: (nickName: String?, category: Int?, links: [String]?, introduce: String?)
    ) -> Observable<Void> {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .flatMapLatest { information in
                        return self.userInformationRepository.upsertUserInformation(
                            userID: userID,
                            nickName: updateInformation.nickName ?? information.nickName,
                            profilePath: nil,
                            jobCategory: updateInformation.category ?? information.jobCategory,
                            links: updateInformation.links ?? information.links,
                            introduce: updateInformation.introduce ?? information.introduce,
                            isCreator: information.isCreator,
                            createdAt: information.createdDate
                        )
                        .andThen(Observable<Void>.just(()))
                    }
            }
    }
    
    func updateUserInformation(
        updateInformation: (jobCategory: Int, links: [String], introduce: String)
    ) -> Observable<Void> {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .flatMapLatest { information in
                        return self.userInformationRepository.upsertUserInformation(
                            userID: userID,
                            nickName: information.nickName,
                            profilePath: nil,
                            jobCategory: updateInformation.jobCategory,
                            links: updateInformation.links,
                            introduce: updateInformation.introduce,
                            isCreator: information.isCreator,
                            createdAt: information.createdDate
                        )
                        .andThen(Observable<Void>.just(()))
                    }
            }
    }
}
