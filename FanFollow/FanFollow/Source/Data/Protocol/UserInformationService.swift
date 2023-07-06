//
//  UserInformationService.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/05.
//

import Foundation
import RxSwift

protocol UserInformationService: SupabaseService {
    func fetchCreatorInformations(
        jobCategory: Int?,
        nickName: String?,
        startRange: Int,
        endRange: Int
    ) -> Observable<[UserInformationDTO]>
    func fetchUserInformation(for userID: String) -> Observable<UserInformationDTO>
    func upsertUserInformation(
        userID: String, name: String, nickName: String, profilePath: String?, jobCategory: Int?,
        links: [String]?, introduce: String?, isCreator: Bool, createdAt: String
    ) -> Completable
    func deleteUserInformation(userID: String) -> Completable
}
