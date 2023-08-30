//
//  ResolveBlockCreatorUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol ResolveBlockCreatorUseCase: AnyObject {
    func resolveBlockCreatorAndRefresh(to banID: String) -> Observable<[Creator]>
}

final class DefaultResolveBlockCreatorUseCase: ResolveBlockCreatorUseCase {
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
            .asObservable()
            .flatMap { _ in
                return self.authRepository.storedSession()
            }
            .flatMap {
                return self.blockCreatorRepository.fetchBlockUsers(to: $0.userID)
            }
            .flatMap { userIDs in
                return Observable.from(userIDs.map(\.bannedID))
            }
            .flatMap { userID in
                return self.userInformationRepository.fetchUserInformation(for: userID)
                    .map { Creator($0) }
            }
            .toArray()
            .asObservable()
    }
}
