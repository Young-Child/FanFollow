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
            .set(path: "/rest/v1/LIKE")
            .set(queryItems: [
                "post_id": "eq.\(postId)"
            ])
            .set(method: .get)
            .set(headers: [:])
            .build()
    }
}
