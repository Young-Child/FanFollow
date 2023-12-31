//
//  ManageBlockCreatorUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol ManageBlockCreatorUseCase: AnyObject {
    func fetchBlockCreators() -> Observable<[Creator]>

    func resolveBlockCreatorAndRefresh(to banID: String) -> Observable<[Creator]>

    func blockCreator(to banID: String) -> Completable

    func resolveBlockCreator(to banID: String) -> Completable
}

final class DefaultManageBlockCreatorUseCase: ManageBlockCreatorUseCase {
    private let blockCreatorRepository: BlockUserRepository
    private let userInformationRepository: UserInformationRepository
    private let followRepository: FollowRepository
    private let authRepository: AuthRepository

    init(
        blockCreatorUseCase: BlockUserRepository,
        userInformationRepository: UserInformationRepository,
        followRepository: FollowRepository,
        authRepository: AuthRepository
    ) {
        self.blockCreatorRepository = blockCreatorUseCase
        self.userInformationRepository = userInformationRepository
        self.followRepository = followRepository
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

    func blockCreator(to banID: String) -> Completable {
        return authRepository.storedSession()
            .flatMap {
                return self.followRepository.deleteFollow(
                    followingID: banID,
                    followerID: $0.userID
                )
                .andThen(self.blockCreatorRepository.addBlockUser(to: $0.userID, with: banID))
            }
            .asCompletable()
    }

    func resolveBlockCreator(to banID: String) -> Completable {
        return self.blockCreatorRepository.deleteBlockUser(to: banID)
    }
}
