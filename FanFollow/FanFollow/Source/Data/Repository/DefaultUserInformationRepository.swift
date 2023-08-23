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
            .compactMap { try? JSONDecoder.ISODecoder.decode([UserInformationDTO].self, from: $0) }
    }

    func fetchUserInformation(for userID: String) -> Observable<UserInformationDTO> {
        let reuqest = UserRequestDirector(builder: builder)
            .requestFetchUserInformation(for: userID)

        return networkService.data(reuqest)
            .compactMap {
                try? JSONDecoder.ISODecoder.decode([UserInformationDTO].self, from: $0).first
            }
    }

    func checkSignUpUser(for userID: String) -> Observable<Bool> {
        let request = UserRequestDirector(builder: builder)
            .requestFetchUserInformation(for: userID)

        return networkService.data(request)
            .map {
                guard let result = try? JSONDecoder.ISODecoder.decode(
                    [UserInformationDTO].self,
                    from: $0
                ) else {
                    return false
                }
                return result.isEmpty == false
            }
    }

    func upsertUserInformation(
        userID: String,
        nickName: String,
        profilePath: String?,
        jobCategory: Int?,
        links: [String]?,
        introduce: String?,
        isCreator: Bool,
        createdAt: Date
    ) -> Completable {
        let userInformationDTO = UserInformationDTO(
            userID: userID, nickName: nickName, profilePath: profilePath, jobCategory: jobCategory,
            links: links, introduce: introduce, isCreator: isCreator, createdDate: createdAt
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
    
    func fetchRandomCreatorInformations(
        jobCategory: JobCategory,
        count: Int
    ) -> Observable<[UserInformationDTO]> {
        let request = UserRequestDirector(builder: builder)
            .requestRandomCreatorInformations(jobCategory: jobCategory, count: count)
        
        return networkService.data(request)
            .compactMap { try? JSONDecoder.ISODecoder.decode([UserInformationDTO].self, from: $0) }
    }
    
    func fetchPopularCreatorInformations(
        jobCategory: JobCategory,
        count: Int
    ) -> Observable<[UserInformationDTO]> {
        let request = UserRequestDirector(builder: builder)
            .requestPopularCreatorInformations(jobCategory: jobCategory, count: count)
        
        return networkService.data(request)
            .compactMap { try? JSONDecoder.ISODecoder.decode([UserInformationDTO].self, from: $0) }
    }
}
