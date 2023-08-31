//
//  PostRequestDirector.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation

struct PostRequestDirector {
    private let builder: URLRequestBuilder

    init(builder: URLRequestBuilder) {
        self.builder = builder
    }

    func requestMyPosts(userID: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.fetchMyPostsPath)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json
            ])
            .set(body: [
                SupabaseConstants.Constants.myUserID: userID,
                SupabaseConstants.Constants.startRange: startRange,
                SupabaseConstants.Constants.endRange: endRange
            ])
            .setAccessKey()
            .build()
    }

    func requestFollowPosts(followerID: String, startRange: Int, endRange: Int) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.fetchFollowPostsPath)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json
            ])
            .set(body: [
                SupabaseConstants.Constants.followerID: followerID,
                SupabaseConstants.Constants.startRange: startRange,
                SupabaseConstants.Constants.endRange: endRange
            ])
            .setAccessKey()
            .build()
    }

    func requestPostUpsert(item: PostDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.path)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.upsertPrefer
            ])
            .set(body: item.convertBody())
            .setAccessKey()
            .build()
    }

    func requestDeletePost(postID: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.postID: SupabaseConstants.Base.equal + postID
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
        static let path = Base.basePath + "POST"
        static let authKey = Base.bearer + Bundle.main.apiKey
        static let upsertPrefer = "resolution=merge-duplicates"
        static let userID = "user_id"
        static let postID = "post_id"
        static let fetchMyPostsPath = Base.basePath + "rpc/fetch_my_posts"
        static let fetchFollowPostsPath = Base.basePath + "rpc/fetch_follow_posts"
        static let followerID = "follower_id"
        static let myUserID = "my_user_id"
        static let startRange = "start_range"
        static let endRange = "end_range"
    }
}
