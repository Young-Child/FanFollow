//
//  PostRequestDirector.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation

struct PostRequestDirector {
    let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestGetPost(range: String) -> URLRequest {
        return builder
            .set(method: .get)
            .set(path: "rest/v1/Post")
            .set(queryItems: ["select" : "*"])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": Bundle.main.apiKey,
                "Range": range
            ])
            .build()
    }
    
    func requestPostUpsert(item: PostDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: "rest/v1/Post")
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": Bundle.main.apiKey,
                "Content-Type" : "application/json",
                "Prefer": "resolution=merge-duplicates"
            ])
            .set(body: item.convertBody())
            .build()
    }
    
    func requestDeletePost(postID: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: "rest/v1/Post")
            .set(queryItems: ["postId": "eq" + postID])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": Bundle.main.apiKey
            ])
            .build()
    }
}
