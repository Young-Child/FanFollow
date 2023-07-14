//
//  StubPostRepository.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/13.
//

import RxSwift

@testable import FanFollow

final class StubPostRepository: PostRepository {
    var posts = [PostDTO]()
    var error: Error?

    func fetchMyPosts(userID: String, startRange: Int, endRange: Int) -> Observable<[PostDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchFollowPosts(followerID: String, startRange: Int, endRange: Int) -> Observable<[PostDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.posts)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func upsertPost(
        postID: String?, userID: String, createdDate: String,
        title: String, content: String, imageURLs: [String]?, videoURL: String?
    ) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }

    func deletePost(postID: String) -> Completable {
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
