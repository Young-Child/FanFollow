//
//  PostService.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation
import RxSwift

protocol PostService {
    func fetchPost() -> Observable<Data>
    
    func upsertPost(
        postID: String?,
        userID: String,
        title: String,
        description: String,
        imageURLs: [String],
        videoURL: String
    ) -> Completable
    
    func deletePost(postID: String) -> Completable
}
