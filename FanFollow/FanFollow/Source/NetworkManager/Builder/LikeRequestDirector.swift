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
            .set(path: "/rest/v1/Like")
            .set(queryItems: [
                "postId": "eq.\(postId)"
            ])
            .set(method: .get)
            .set(headers: [:])
            .build()
    }
}
