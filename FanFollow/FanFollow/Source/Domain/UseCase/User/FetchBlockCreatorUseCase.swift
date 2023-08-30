//
//  FetchBlockUserUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol FetchBlockCreatorUseCase: AnyObject {
    func fetchBlockCreators() -> Observable<[Creator]>
}

final class DefaultFetchBlockCreatorUseCase: FetchBlockCreatorUseCase {
    private let userInformationRepository: UserInformationRepository
    private let blockUserRepository: BlockUserRepository
    private let authRepository: AuthRepository
    
    init(
        userInformationRepository: UserInformationRepository,
        blockUserRepository: BlockUserRepository,
        authRepository: AuthRepository
    ) {
        self.userInformationRepository = userInformationRepository
        self.blockUserRepository = blockUserRepository
        self.authRepository = authRepository
    }
    
    func fetchBlockCreators() -> Observable<[Creator]> {
        return authRepository.storedSession()
            .flatMap {
                return self.blockUserRepository.fetchBlockUsers(to: $0.userID)
            }
            .flatMap { userIDs in return Observable.from(userIDs.map(\.bannedID)) }
            .flatMap { userID in
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .map { Creator($0) }
            }
            .toArray()
            .asObservable()
    }
}
