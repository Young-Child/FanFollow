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
            .set(path: SupabaseConstants.Constant.path)
            .set(queryItems: [
                SupabaseConstants.Constant.postID: SupabaseConstants.Constant.equalPostID
            ])
            .set(method: .get)
            .set(headers: [:])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constant {
        static let path = Base.basePath + "LIKE"
        static let authKey = Base.bearer + Bundle.main.apiKey
        static let upsertPrefer = "resolution=merge-duplicates"
        static let postID = "post_id"
        static let equalPostID = Base.equal + postID
    }
}
