//
//  StubLikeRepository.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/13.
//

import RxSwift

@testable import FanFollow

final class StubLikeRepository: LikeRepository {
    var count = 0
    var error: Error?
    var isCreatePostLikeCalled = false
    var isDeletePostLikeCalled = false

    func fetchPostLikeCount(postID: String, userID: String?) -> Observable<Int> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.count)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func createPostLike(postID: String, userID: String) -> Completable {
        isCreatePostLikeCalled = true

        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }

    func deletePostLike(postID: String, userID: String) -> Completable {
        isDeletePostLikeCalled = true

        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }
}
