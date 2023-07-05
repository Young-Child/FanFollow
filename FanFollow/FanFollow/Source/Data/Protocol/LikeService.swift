//
//  LikeService.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/04.
//

import Foundation
import RxSwift

protocol LikeService: SupabaseService {
    func fetchPostLikeCount(postID: String) -> Observable<Int>
    func createPostLike(postID: String, userID: String) -> Completable
}