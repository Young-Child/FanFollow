//
//  DefaultUserInformationRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/05.
//

import Foundation
import RxSwift

struct DefaultUserInformationRepository: UserInformationRepository {
    private let networkService: NetworkService

    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchCreatorInformations(
        jobCategory: Int? = nil,
        nickName: String? = nil,
        startRange: Int,
        endRange: Int
    ) -> Observable<[UserInformationDTO]> {
        let request = UserRequestDirector(builder: builder)
            .requestFetchCreatorInformations(
                jobCategory: jobCategory,
                nickName: nickName,
                startRange: startRange,
                endRange: endRange
            )

        return networkService.data(request)
            .compactMap { try? JSONDecoder().decode([UserInformationDTO].self, from: $0) }
    }

    func fetchUserInformation(for userID: String) -> Observable<UserInformationDTO> {
        let reuqest = UserRequestDirector(builder: builder)
            .requestFetchUserInformation(for: userID)

        return networkService.data(reuqest)
            .compactMap { try? JSONDecoder().decode([UserInformationDTO].self, from: $0).first }
    }

    func upsertUserInformation(
        userID: String,
        name: String,
        nickName: String,
        profilePath: String?,
        jobCategory: Int?,
        links: [String]?,
        introduce: String?,
        isCreator: Bool,
        createdAt: String
    ) -> Completable {
        let userInformationDTO = UserInformationDTO(
            userID: userID, name: name, nickName: nickName, profilePath: profilePath, jobCategory: jobCategory,
            links: links, introduce: introduce, isCreator: isCreator, createdAt: createdAt
        )

        let request = UserRequestDirector(builder: builder)
            .requestUpsertUserInformation(userInformationDTO: userInformationDTO)

        return networkService.execute(request)
    }

    func deleteUserInformation(userID: String) -> Completable {
        let request = UserRequestDirector(builder: builder)
            .requestDeleteUserInformation(userID: userID)

        return networkService.execute(request)
    }
}
