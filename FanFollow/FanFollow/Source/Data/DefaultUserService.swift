//
//  DefaultUserService.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/05.
//

import Foundation
import RxSwift

struct DefaultUserService: UserService {
    private let networkManger: Network

    init(_ networkManger: Network = NetworkManager()) {
        self.networkManger = networkManger
    }

    func fetchUserInformations(jobCategory: Int, startRange: Int, endRange: Int) -> Observable<[UserInformationDTO]> {
        let request = UserRequestDirector(builder: builder)
            .requestFetchUserInformationList(jobCategory: jobCategory, startRange: startRange, endRange: endRange)

        return networkManger.data(request)
            .compactMap { try? JSONDecoder().decode([UserInformationDTO].self, from: $0) }
    }

    func fetchUserInformations(nickName: String, startRange: Int, endRange: Int) -> Observable<[UserInformationDTO]> {
        let request = UserRequestDirector(builder: builder)
            .requestFetchUserInformationList(nickName: nickName, startRange: startRange, endRange: endRange)

        return networkManger.data(request)
            .compactMap { try? JSONDecoder().decode([UserInformationDTO].self, from: $0) }
    }

    func fetchUserInformation(for userID: String) -> Observable<UserInformationDTO> {
        let reuqest = UserRequestDirector(builder: builder)
            .requestFetchUserInformation(for: userID)

        return networkManger.data(reuqest)
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
    ) -> RxSwift.Completable {
        let userInformationDTO = UserInformationDTO(
            userID: userID, name: name, nickName: nickName, profilePath: profilePath, jobCategory: jobCategory,
            links: links, introduce: introduce, isCreator: isCreator, createdAt: createdAt
        )

        let request = UserRequestDirector(builder: builder)
            .requestUpsertUserInformation(userInformationDTO: userInformationDTO)

        return networkManger.execute(request)
    }

    func deleteUserInformation(userID: String) -> Completable {
        let request = UserRequestDirector(builder: builder)
            .requestDeleteUserInformation(userID: userID)

        return networkManger.execute(request)
    }
}
