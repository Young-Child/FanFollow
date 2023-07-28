//
//  FetchCreatorInformationUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol FetchCreatorInformationUseCase: AnyObject {
    func fetchCreatorInformation(for creatorID: String) -> Observable<Creator>
    func fetchFollowerCount(for creatorID: String) -> Observable<Int>
    func fetchFollowings(for userID: String, startRange: Int, endRange: Int) -> Observable<[Creator]>
    func checkFollow(creatorID: String, userID: String) -> Observable<Bool>
    func toggleFollow(creatorID: String, userID: String) -> Completable
}

final class DefaultFetchCreatorInformationUseCase: FetchCreatorInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    private let followRepository: FollowRepository

    init(userInformationRepository: UserInformationRepository, followRepository: FollowRepository) {
        self.userInformationRepository = userInformationRepository
        self.followRepository = followRepository
    }

    func fetchCreatorInformation(for creatorID: String) -> Observable<Creator> {
        return userInformationRepository.fetchUserInformation(for: creatorID)
            .compactMap { userInformationDTO in
                return Creator(userInformationDTO)
            }
    }

    func fetchFollowerCount(for creatorID: String) -> Observable<Int> {
        return followRepository.fetchFollowerCount(followingID: creatorID)
    }
    
    func fetchFollowings(for userID: String, startRange: Int, endRange: Int) -> Observable<[Creator]> {
        return followRepository
            .fetchFollowers(followingID: userID, startRange: startRange, endRange: endRange)
            .map { followDTOList in
                followDTOList.map { followDTO in
                    return Creator(followDTO.userInformation)
                }
            }
    }

    func checkFollow(creatorID: String, userID: String) -> Observable<Bool> {
        return followRepository.checkFollow(followingID: creatorID, followerID: userID)
    }

    func toggleFollow(creatorID: String, userID: String) -> Completable {
        return checkFollow(creatorID: creatorID, userID: userID)
            .flatMap { isFollow in
                if isFollow {
                    return self.followRepository.deleteFollow(followingID: creatorID, followerID: userID)
                } else {
                    return self.followRepository.insertFollow(followingID: creatorID, followerID: userID)
                }
            }
            .asCompletable()
    }
}
