//
//  LikeRequestDirector.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct LikeRequestDirector {
    let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestUserLikeCount(postID: String, userID: String? = nil) -> URLRequest {
        var queryItems: [String: String] = [
            SupabaseConstants.Base.select: SupabaseConstants.Base.count,
            SupabaseConstants.Constants.postID: SupabaseConstants.Base.equal + postID
        ]
        
        if let userID = userID {
            queryItems[SupabaseConstants.Constants.userID] = SupabaseConstants.Base.equal + userID
        }
        
        return builder
            .set(method: .get)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: queryItems)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }
    
    func requestCreatePostLike(postID: String, userID: String) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.path)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.createPrefer
            ])
            .set(body: [
                SupabaseConstants.Constants.postID: postID,
                SupabaseConstants.Constants.userID: userID
            ])
            .setAccessKey()
            .build()
    }
    
    func requestDeleteUserLike(postID: String, userID: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.postID: SupabaseConstants.Base.equal + postID,
                SupabaseConstants.Constants.userID: SupabaseConstants.Base.equal + userID
            ])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "LIKE"
        static let createPrefer = "return=minimal"
        static let postID = "post_id"
        static let userID = "user_id"
        static let countExact = Base.count + "exact"
    }
}
