//
//  ChangeLikeUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol ChangeLikeUseCase: AnyObject {
    func checkPostLiked(by userID: String, postID: String) -> Observable<Bool>
    func fetchPostLikeCount(postID: String) -> Observable<Int>
    func createPostLike(postID: String, userID: String) -> Completable
    func deletePostLike(postID: String, userID: String) -> Completable
}

final class DefaultChangeLikeUseCase: ChangeLikeUseCase {
    private let likeRepository: LikeRepository

    init(likeRepository: LikeRepository) {
        self.likeRepository = likeRepository
    }

    func checkPostLiked(by userID: String, postID: String) -> Observable<Bool> {
        return likeRepository
            .fetchPostLikeCount(postID: postID, userID: userID)
            .map { count in
                return count > 0
            }
    }

    func fetchPostLikeCount(postID: String) -> Observable<Int> {
        return likeRepository.fetchPostLikeCount(postID: postID, userID: nil)
    }

    func createPostLike(postID: String, userID: String) -> Completable {
        return likeRepository.createPostLike(postID: postID, userID: userID)
    }

    func deletePostLike(postID: String, userID: String) -> Completable {
        return likeRepository.deletePostLike(postID: postID, userID: userID)
    }
}

