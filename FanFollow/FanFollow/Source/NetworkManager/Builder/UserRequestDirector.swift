//
//  UserRequestDirector.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/05.
//

import Foundation

struct UserRequestDirector {
    private let builder: URLRequestBuilder

    init(builder: URLRequestBuilder) {
        self.builder = builder
    }

    func requestFetchUserInformationList(jobCategory: Int, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.jobCategory: SupabaseConstants.Base.equal + "\(jobCategory)",
                SupabaseConstants.Base.select: SupabaseConstants.Base.selectAll
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFetchUserInformationList(nickName: String, startRange: Int, endRange: Int) -> URLRequest {
        let pattern = SupabaseConstants.Constants.percentSymbol + nickName + SupabaseConstants.Constants.percentSymbol

        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.nickName: SupabaseConstants.Constants.ilike + pattern,
                SupabaseConstants.Constants.isCreator: SupabaseConstants.Constants.equalTrue,
                SupabaseConstants.Base.select: SupabaseConstants.Base.selectAll
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFetchUserInformation(for userID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.userID: SupabaseConstants.Base.equal + userID,
                SupabaseConstants.Base.select: SupabaseConstants.Base.selectAll
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey
            ])
            .build()
    }

    func requestUpsertUserInformation(userInformationDTO: UserInformationDTO) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.resolutionMergeDuplicates
            ])
            .set(body: userInformationDTO.convertBody())
            .build()
    }

    func requestDeleteUserInformation(userID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.userID: SupabaseConstants.Base.equal + userID
            ])
            .set(method: .delete)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "USER_INFORMATION"
        static let jobCategory = "job_category"
        static let nickName = "nick_name"
        static let userID = "user_id"
        static let isCreator = "is_creator"
        static let equalTrue = Base.equal + "true"
        static let ilike = "ilike."
        static let percentSymbol = "%"
        static let resolutionMergeDuplicates = "resolution=merge-duplicates"
    }
}
