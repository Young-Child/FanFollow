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
}
