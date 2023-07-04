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
            .set(path: "/rest/v1/Follow")
            .set(queryItems: [
                "followingId": "eq.\(followingId)",
                "select": "*,UserInformation!Follow_followerId_fkey(*)"
            ])
            .set(method: .get)
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)",
                "Ragne": "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFollowingList(_ followerId: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(path: "/rest/v1/Follow")
            .set(queryItems: [
                "followerId": "eq.\(followerId)",
                "select": "*,UserInformation!Follow_followingId_fkey(*)"
            ])
            .set(method: .get)
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)",
                "Ragne": "\(startRange)-\(endRange)"
            ])
            .build()
    }

    func requestFollowCount(followingId: String? = nil, followerId: String? = nil) -> URLRequest {
        var queryItems = ["select": "id"]
        if let followingId {
            queryItems["followingId"] = "eq.\(followingId)"
        }
        if let followerId {
            queryItems["followerId"] = "eq.\(followerId)"
        }

        return builder
            .set(path: "/rest/v1/Follow")
            .set(queryItems: queryItems)
            .set(method: .get)
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)",
                "Prefer": "count=exact"
            ])
            .build()
    }

    func requestInsertFollow(followerId: String, followingId: String) -> URLRequest {
        return builder
            .set(path: "/rest/v1/Follow")
            .set(method: .post)
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)",
                "Content-Type": "application/json",
                "Prefer": "return=minimal"
            ])
            .set(body: [
                "followerId": "\(followerId)",
                "followingId": "\(followingId)"
            ])
            .build()
    }

    func requestDeleteFollow(followerId: String, followingId: String) -> URLRequest {
        return builder
            .set(path: "/rest/v1/Follow")
            .set(queryItems: [
                "followerId": "eq.\(followerId)",
                "followingId": "eq.\(followingId)"
            ])
            .set(method: .delete)
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .build()
    }
}
