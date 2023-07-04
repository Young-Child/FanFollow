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
            .set(path: "\(Constant.Text.basePath)FOLLOW")
            .set(queryItems: [
                "following_id": "eq.\(followingId)",
                Constant.Text.select: "*,USER_INFORMATION!FOLLOW_follower_id_fkey(*)"
            ])
            .set(method: .get)
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: "\(Constant.Text.bearer)\(Bundle.main.apiKey)",
                "Range": "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFollowingList(_ followerId: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: "\(Constant.Text.basePath)FOLLOW")
            .set(queryItems: [
                "follower_id": "eq.\(followerId)",
                Constant.Text.select: "*,USER_INFORMATION!FOLLOW_following_id_fkey(*)"
            ])
            .set(method: .get)
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: "\(Constant.Text.bearer)\(Bundle.main.apiKey)",
                "Range": "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFollowCount(followingId: String? = nil, followerId: String? = nil) -> URLRequest {
        var queryItems = [Constant.Text.select: "follow_id"]
        if let followingId {
            queryItems["following_id"] = "eq.\(followingId)"
        }
        if let followerId {
            queryItems["follower_id"] = "eq.\(followerId)"
        }

        return builder
            .set(path: "\(Constant.Text.basePath)FOLLOW")
            .set(queryItems: queryItems)
            .set(method: .get)
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: "\(Constant.Text.bearer)\(Bundle.main.apiKey)",
                "Prefer": "count=exact"
            ])
            .build()
    }

    func requestInsertFollow(followerId: String, followingId: String) -> URLRequest {
        return builder
            .set(path: "\(Constant.Text.basePath)FOLLOW")
            .set(method: .post)
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: "\(Constant.Text.bearer)\(Bundle.main.apiKey)",
                "Content-Type": "application/json",
                "Prefer": "return=minimal"
            ])
            .set(body: [
                "follower_id": "\(followerId)",
                "following_id": "\(followingId)"
            ])
            .build()
    }

    func requestDeleteFollow(followerId: String, followingId: String) -> URLRequest {
        return builder
            .set(path: "\(Constant.Text.basePath)FOLLOW")
            .set(queryItems: [
                "follower_id": "eq.\(followerId)",
                "following_id": "eq.\(followingId)"
            ])
            .set(method: .delete)
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: "\(Constant.Text.bearer)\(Bundle.main.apiKey)"
            ])
            .build()
    }
}
