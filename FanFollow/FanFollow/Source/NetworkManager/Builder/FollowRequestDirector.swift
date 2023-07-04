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

    func requestFollowerList(_ followingId: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.followingId: SupabaseConstants.Base.equal + followingId,
                SupabaseConstants.Base.select: SupabaseConstants.Constants.selectFollowerList
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFollowingList(_ followerId: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.followerId: SupabaseConstants.Base.equal + followerId,
                SupabaseConstants.Base.select: SupabaseConstants.Constants.selectFollowingList
            ])
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.range: "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFollowCount(followingId: String? = nil, followerId: String? = nil) -> URLRequest {
        var queryItems = [SupabaseConstants.Base.select: SupabaseConstants.Constants.followId]
        if let followingId {
            queryItems[SupabaseConstants.Constants.followingId] = SupabaseConstants.Base.equal + followingId
        }
        if let followerId {
            queryItems[SupabaseConstants.Constants.followerId] = SupabaseConstants.Base.equal + followerId
        }

        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: queryItems)
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.countExact
            ])
            .build()
    }

    func requestInsertFollow(followerId: String, followingId: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.returnMinimal
            ])
            .set(body: [
                SupabaseConstants.Constants.followerId: "\(followerId)",
                SupabaseConstants.Constants.followingId: "\(followingId)"
            ])
            .build()
    }

    func requestDeleteFollow(followerId: String, followingId: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.followerId: SupabaseConstants.Base.equal + followerId,
                SupabaseConstants.Constants.followingId: SupabaseConstants.Base.equal + followingId
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
        static let path = Base.basePath + "FOLLOW"
        static let followingId = "following_id"
        static let followerId = "follower_id"
        static let followId = "follow_id"
        static let selectFollowerList = "*,USER_INFORMATION!FOLLOW_follower_id_fkey(*)"
        static let selectFollowingList = "*,USER_INFORMATION!FOLLOW_following_id_fkey(*)"
        static let equalFollowingId = Base.equal + followingId
        static let returnMinimal = "return=minimal"
        static let countExact = Base.count + "exact"
    }
}
