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
    func changePostLike(postID: String, userID: String) -> Completable
    func checkUserPostLike(postID: String, userID: String) -> Observable<Bool>
}
