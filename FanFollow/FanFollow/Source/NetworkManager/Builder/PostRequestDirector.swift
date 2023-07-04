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
            .set(path: Constant.Text.basePath + "POST")
            .set(queryItems: [Constant.Text.select : Constant.Text.selectAll])
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: Constant.Text.bearer + Bundle.main.apiKey,
                "Range": range
            ])
            .build()
    }
    
    func requestPostUpsert(item: PostDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: Constant.Text.basePath + "POST")
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: Constant.Text.bearer + Bundle.main.apiKey,
                "Content-Type" : "application/json",
                "Prefer": "resolution=merge-duplicates"
            ])
            .set(body: item.convertBody())
            .build()
    }
    
    func requestDeletePost(postID: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: Constant.Text.basePath + "POST")
            .set(queryItems: ["post_id": "eq." + postID])
            .set(headers: [
                Constant.Text.apikey: Bundle.main.apiKey,
                Constant.Text.authorization: Constant.Text.bearer + Bundle.main.apiKey
            ])
            .build()
    }
}
