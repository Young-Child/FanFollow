//
//  LikeRepository.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/04.
//

import Foundation
import RxSwift

protocol LikeRepository: SupabaseEndPoint {
    func fetchPostLikeCount(postID: String, userID: String?) -> Observable<Int>
    func createPostLike(postID: String, userID: String) -> Completable
    func deletePostLike(postID: String, userID: String) -> Completable
}
