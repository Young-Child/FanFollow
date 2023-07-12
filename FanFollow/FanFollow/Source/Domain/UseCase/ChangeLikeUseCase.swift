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
    func togglePostLike(postID: String, userID: String) -> Completable
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

    func togglePostLike(postID: String, userID: String) -> Completable {
        return checkPostLiked(by: userID, postID: postID)
            .flatMap { liked in
                if liked {
                    return self.likeRepository.deletePostLike(postID: postID, userID: userID)
                        .asObservable()
                } else {
                    return self.likeRepository.createPostLike(postID: postID, userID: userID)
                        .asObservable()
                }
            }
            .asCompletable()
    }
}

