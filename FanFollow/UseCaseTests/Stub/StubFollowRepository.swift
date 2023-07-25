//
//  StubFollowRepository.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/25.
//

import RxSwift

@testable import FanFollow

final class StubFollowRepository: FollowRepository {
    var follows = [FollowDTO]()
    var followerCount = 0
    var followingCount = 0
    var isFollow = true
    var error: Error?


    func fetchFollowers(followingID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.follows)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchFollowings(followerID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.follows)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchFollowerCount(followingID: String) -> Observable<Int> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.followerCount)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchFollowingCount(followerID: String) -> Observable<Int> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.followingCount)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func checkFollow(followingID: String, followerID: String) -> Observable<Bool> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.isFollow)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func insertFollow(followingID: String, followerID: String) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }

    func deleteFollow(followingID: String, followerID: String) -> Completable {
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
