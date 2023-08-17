//
//  ChangeLikeUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol ChangeLikeUseCase: AnyObject {
    func checkPostLiked(postID: String) -> Observable<Bool>
    func fetchPostLikeCount(postID: String) -> Observable<Int>
    func togglePostLike(postID: String, userID: String) -> Completable
}

final class DefaultChangeLikeUseCase: ChangeLikeUseCase {
    private let likeRepository: LikeRepository
    private let authRepository: AuthRepository

    init(likeRepository: LikeRepository, authRepository: AuthRepository) {
        self.likeRepository = likeRepository
        self.authRepository = authRepository
    }

    func checkPostLiked(postID: String) -> Observable<Bool> {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.likeRepository
                    .fetchPostLikeCount(postID: postID, userID: userID)
                    .map { count in
                        return count > 0
                    }
            }
    }

    func fetchPostLikeCount(postID: String) -> Observable<Int> {
        return likeRepository.fetchPostLikeCount(postID: postID, userID: nil)
    }

    func togglePostLike(postID: String, userID: String) -> Completable {
        return checkPostLiked(postID: postID)
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

