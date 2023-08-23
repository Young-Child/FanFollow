//
//  FetchCreatorInformationUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol FetchCreatorInformationUseCase: AnyObject {
    func fetchCreatorInformation(targetID: String) -> Observable<Creator>
    func fetchFollowerCount(targetID: String) -> Observable<Int>
    func fetchFollowingCreators(
        targetID: String,
        startRange: Int,
        endRange: Int
    ) -> Observable<[Creator]>
    func checkFollow(targetID: String) -> Observable<Bool>
    func toggleFollow(targetID: String) -> Completable
}

final class DefaultFetchCreatorInformationUseCase: FetchCreatorInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    private let followRepository: FollowRepository
    private let authRepository: AuthRepository

    init(
        userInformationRepository: UserInformationRepository,
        followRepository: FollowRepository,
        authRepository: AuthRepository
    ) {
        self.userInformationRepository = userInformationRepository
        self.followRepository = followRepository
        self.authRepository = authRepository
    }

    func fetchCreatorInformation(targetID: String) -> Observable<Creator> {
        return self.userInformationRepository.fetchUserInformation(for: targetID)
            .compactMap { userInformationDTO in
                return Creator(userInformationDTO)
            }
    }

    func fetchFollowerCount(targetID: String) -> Observable<Int> {
        return self.followRepository.fetchFollowerCount(followingID: targetID)
    }
    
    func fetchFollowingCreators(
        targetID: String,
        startRange: Int,
        endRange: Int
    ) -> Observable<[Creator]> {
        return self.followRepository
            .fetchFollowings(followerID: targetID, startRange: startRange, endRange: endRange)
            .map { followDTOList in
                followDTOList.map { followDTO in
                    return Creator(followDTO.userInformation)
                }
            }
    }

    func checkFollow(targetID: String) -> Observable<Bool> {
        authRepository.storedSession()
            .flatMap { storedSession in
                let sessionID = storedSession.userID
                return self.followRepository
                    .checkFollow(followingID: targetID, followerID: sessionID)
            }
    }

    func toggleFollow(targetID: String) -> Completable {
        authRepository.storedSession()
            .flatMap { storedSession in
                let sessionID = storedSession.userID
                return self.checkFollow(targetID: targetID)
                    .flatMap { isFollow in
                        if isFollow {
                            return self.followRepository
                                .deleteFollow(followingID: targetID, followerID: sessionID)
                        } else {
                            return self.followRepository
                                .insertFollow(followingID: targetID, followerID: sessionID)
                        }
                    }
            }
            .asCompletable()
    }
}
