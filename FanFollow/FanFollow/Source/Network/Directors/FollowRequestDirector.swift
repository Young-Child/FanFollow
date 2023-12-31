//
//  FollowRequestDirector.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation

struct FollowRequestDirector {
    private let builder: URLRequestBuilder

    init(builder: URLRequestBuilder) {
        self.builder = builder
    }

    func requestFollowerList(_ followingID: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.followingID: SupabaseConstants.Base.equal + followingID,
                SupabaseConstants.Base.select: SupabaseConstants.Constants.selectFollowerList
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .setAccessKey()
            .build()
    }

    func requestFollowingList(_ followerID: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.followerID: SupabaseConstants.Base.equal + followerID,
                SupabaseConstants.Base.select: SupabaseConstants.Constants.selectFollowingList
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .setAccessKey()
            .build()
    }

    func requestFollowCount(followingID: String? = nil, followerID: String? = nil) -> URLRequest {
        var queryItems = [SupabaseConstants.Base.select: SupabaseConstants.Constants.count]
        
        if let followingID {
            let value = SupabaseConstants.Base.equal + followingID
            queryItems[SupabaseConstants.Constants.followingID] = value
        }
        
        if let followerID {
            let value = SupabaseConstants.Base.equal + followerID
            queryItems[SupabaseConstants.Constants.followerID] = value
        }

        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: queryItems)
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }

    func requestInsertFollow(followingID: String, followerID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.returnMinimal
            ])
            .set(body: [
                SupabaseConstants.Constants.followingID: "\(followingID)",
                SupabaseConstants.Constants.followerID: "\(followerID)"
            ])
            .setAccessKey()
            .build()
    }

    func requestDeleteFollow(followingID: String, followerID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.followingID: SupabaseConstants.Base.equal + followingID,
                SupabaseConstants.Constants.followerID: SupabaseConstants.Base.equal + followerID
            ])
            .set(method: .delete)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "FOLLOW"
        static let followingID = "following_id"
        static let followerID = "follower_id"
        static let followID = "follow_id"
        static let selectFollowerList = "*,USER_INFORMATION!FOLLOW_follower_id_fkey(*)"
        static let selectFollowingList = "*,USER_INFORMATION!FOLLOW_following_id_fkey(*)"
        static let equalFollowingID = Base.equal + followingID
        static let returnMinimal = "return=minimal"
        static let count = "count"
    }
}
