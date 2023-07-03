//
//  ChatRequestDirector.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ChatRequestDirector {
    let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestChattingList(userId: String) -> URLRequest {
        return builder
            .set(method: .get)
            .set(path: "/rest/v1/Chat")
            .set(queryItems: ["id": "eq.\(userId)"])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .build()
    }
}
