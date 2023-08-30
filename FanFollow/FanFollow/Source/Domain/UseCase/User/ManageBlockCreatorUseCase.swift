//
//  ManageBlockCreatorUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol ManageBlockCreatorUseCase: AnyObject {
    func resolveBlockCreatorAndRefresh(to banID: String) -> Observable<[Creator]>
}

final class DefaultManageBlockCreatorUseCase: ManageBlockCreatorUseCase {
    private let blockCreatorRepository: BlockUserRepository
    private let userInformationRepository: UserInformationRepository
    private let authRepository: AuthRepository
    
    init(
        blockCreatorUseCase: BlockUserRepository,
        userInformationRepository: UserInformationRepository,
        authRepository: AuthRepository
    ) {
        self.blockCreatorRepository = blockCreatorUseCase
        self.userInformationRepository = userInformationRepository
        self.authRepository = authRepository
    }
    
    func resolveBlockCreatorAndRefresh(to banID: String) -> Observable<[Creator]> {
        return self.blockCreatorRepository.deleteBlockUser(to: banID)
            .andThen(fetchBlockCreators())
    }
    
    func fetchBlockCreators() -> Observable<[Creator]> {
        return authRepository.storedSession()
            .flatMap {
                return self.blockCreatorRepository.fetchBlockUsers(to: $0.userID)
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
