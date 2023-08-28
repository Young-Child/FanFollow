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

    func requestFetchCreatorInformations(
        jobCategory: Int? = nil,
        nickName: String? = nil,
        startRange: Int,
        endRange: Int
    ) -> URLRequest {
        var queryItems = [
            SupabaseConstants.Base.select: SupabaseConstants.Base.selectAll,
            SupabaseConstants.Constants.isCreator: SupabaseConstants.Constants.equalTrue
        ]
        if let jobCategory {
            let value = SupabaseConstants.Base.equal + "\(jobCategory)"
            queryItems[SupabaseConstants.Constants.jobCategory] = value
        }
        if let nickName {
            let percentSymbol = SupabaseConstants.Constants.percentSymbol
            let pattern = percentSymbol + nickName + percentSymbol
            let value = SupabaseConstants.Constants.ilike + pattern
            queryItems[SupabaseConstants.Constants.nickName] = value
        }

        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: queryItems)
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .setAccessKey()
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
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }

    func requestUpsertUserInformation(userInformationDTO: UserInformationDTO) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.resolutionMergeDuplicates
            ])
            .set(body: userInformationDTO.convertBody())
            .setAccessKey()
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
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }
    
    func requestRandomCreatorInformations(jobCategory: JobCategory, count: Int) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.randomRpcPath)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json
            ])
            .setAccessKey()
            .set(body: [
                SupabaseConstants.Constants.category: jobCategory.rawValue,
                SupabaseConstants.Constants.count: count
            ])
            .build()
    }
    
    func requestPopularCreatorInformations(jobCategory: JobCategory, count: Int) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.popularRpcPath)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json
            ])
            .setAccessKey()
            .set(body: [
                SupabaseConstants.Constants.category: jobCategory.rawValue,
                SupabaseConstants.Constants.count: count
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        // BASE ELEMENT
        static let path = Base.basePath + "USER_INFORMATION"
        static let randomRpcPath = Base.basePath + "rpc/fetch_random_creator"
        static let popularRpcPath = Base.basePath + "rpc/fetch_popular_creator"
        
        // QUERY KEY
        static let jobCategory = "job_category"
        static let nickName = "nick_name"
        static let userID = "user_id"
        static let category = "category"
        static let isCreator = "is_creator"
        static let equalTrue = Base.equal + "true"
        static let ilike = "ilike."
        static let count = "fetchcount"
        static let percentSymbol = "%"
        static let resolutionMergeDuplicates = "resolution=merge-duplicates"
    }
}