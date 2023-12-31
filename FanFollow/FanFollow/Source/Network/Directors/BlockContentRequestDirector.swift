//
//  BlockContentRequestDirector.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/30.
//

import Foundation

struct BlockContentRequestDirector {
    private let builder: URLRequestBuilder

    init(builder: URLRequestBuilder) {
        self.builder = builder
    }

    func requestBlock(postID: String, userID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Base.upsertPrefer,
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .set(body: [
                SupabaseConstants.Constants.postID: postID,
                SupabaseConstants.Constants.userID: userID
            ])
            .setAccessKey()
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        // BASE ELEMENT
        static let path = Base.basePath + "BLOCK_CONTENT"
        
        // QUERY KEY
        static let postID = "post_id"
        static let userID = "user_id"
    }
}
