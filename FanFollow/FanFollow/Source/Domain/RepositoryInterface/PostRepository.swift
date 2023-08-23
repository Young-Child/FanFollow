//
//  PostRepository.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/04.
//

import Foundation
import RxSwift

protocol PostRepository: SupabaseEndPoint {
    func fetchMyPosts(userID: String, startRange: Int, endRange: Int) -> Observable<[PostDTO]>
    
    func fetchFollowPosts(
        followerID: String,
        startRange: Int,
        endRange: Int
    ) -> Observable<[PostDTO]>
    
    func upsertPost(
        postID: String?, userID: String, createdDate: Date,
        title: String, content: String, imageURLs: [String]?, videoURL: String?
    ) -> Completable
    
    func deletePost(postID: String) -> Completable
}
