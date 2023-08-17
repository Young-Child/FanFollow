//
//  FetchCreatorInformationUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol FetchCreatorInformationUseCase: AnyObject {
    func fetchCreatorInformation() -> Observable<Creator>
    func fetchFollowerCount() -> Observable<Int>
    func fetchFollowings(startRange: Int, endRange: Int) -> Observable<[Creator]>
    func checkFollow(userID: String) -> Observable<Bool>
    func toggleFollow(userID: String) -> Completable
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

    func fetchCreatorInformation() -> Observable<Creator> {
        authRepository.storedSession()
            .flatMap { storedSession in
                let creatorID = storedSession.userID
                return self.userInformationRepository.fetchUserInformation(for: creatorID)
                    .compactMap { userInformationDTO in
                        return Creator(userInformationDTO)
                    }
            }
    }

    func fetchFollowerCount() -> Observable<Int> {
        authRepository.storedSession()
            .flatMap { storedSession in
                let creatorID = storedSession.userID
                return self.followRepository.fetchFollowerCount(followingID: creatorID)
            }
    }
    
    func fetchFollowings(startRange: Int, endRange: Int) -> Observable<[Creator]> {
        authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.followRepository
                    .fetchFollowers(followingID: userID, startRange: startRange, endRange: endRange)
                    .map { followDTOList in
                        followDTOList.map { followDTO in
                            return Creator(followDTO.userInformation)
                        }
                    }
            }
    }

    func checkFollow(userID: String) -> Observable<Bool> {
        authRepository.storedSession()
            .flatMap { storedSession in
                let creatorID = storedSession.userID
                return self.followRepository.checkFollow(followingID: creatorID, followerID: userID)
            }
    }

    func toggleFollow(userID: String) -> Completable {
        authRepository.storedSession()
            .flatMap { storedSession in
                let creatorID = storedSession.userID
                return self.checkFollow(userID: userID)
                    .flatMap { isFollow in
                        if isFollow {
                            return self.followRepository.deleteFollow(followingID: creatorID, followerID: userID)
                        } else {
                            return self.followRepository.insertFollow(followingID: creatorID, followerID: userID)
                        }
                    }
            }
            .asCompletable()
    }
}
