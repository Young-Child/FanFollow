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
    
    func requestUserLikeCount(_ postId: String) -> URLRequest {
        return builder
            .set(method: .get)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Base.select: SupabaseConstants.Base.count,
                SupabaseConstants.Constants.postID: SupabaseConstants.Base.equal + postId
            ])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey
            ])
            .build()
    }
    
    func createPostLike(postID: String, userID: String) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.path)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey,
                SupabaseConstants.Base.contentType : SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.createPrefer
            ])
            .set(body: [
                SupabaseConstants.Constants.postID: postID,
                SupabaseConstants.Constants.userID: userID
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "LIKE"
        static let authKey = Base.bearer + Bundle.main.apiKey
        static let createPrefer = "return=minimal"
        static let postID = "post_id"
        static let userID = "user_id"
        static let countExact = Base.count + "exact"
    }
}
