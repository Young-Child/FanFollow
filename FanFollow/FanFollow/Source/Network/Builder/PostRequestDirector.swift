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
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [SupabaseConstants.Base.select : SupabaseConstants.Base.selectAll])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey,
                SupabaseConstants.Base.range: range
            ])
            .build()
    }
    
    func requestPostUpsert(item: PostDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.path)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey,
                SupabaseConstants.Base.contentType : SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.upsertPrefer
            ])
            .set(body: item.convertBody())
            .build()
    }
    
    func requestDeletePost(postID: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [SupabaseConstants.Constants.postID: SupabaseConstants.Base.equal + postID])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey,
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "POST"
        static let authKey = Base.bearer + Bundle.main.apiKey
        static let upsertPrefer = "resolution=merge-duplicates"
        static let postID = "post_id"
    }
}