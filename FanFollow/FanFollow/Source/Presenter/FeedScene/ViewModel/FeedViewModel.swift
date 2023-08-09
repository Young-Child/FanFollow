//
//  FeedViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/17.
//

import Foundation

import RxRelay
import RxSwift

final class FeedViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var refresh: Observable<Void>
        var lastCellDisplayed: Observable<Void>
        var likeButtonTap: Observable<String>
    }

    struct Output {
        var posts: Observable<[PostSectionModel]>
    }

    var disposeBag = DisposeBag()
    private let fetchFeedUseCase: FetchFeedUseCase
    private let changeLikeUseCase: ChangeLikeUseCase
    private let followerID: String
    private let pageSize = 10

    private let posts = BehaviorRelay<[Post]>(value: [])

    init(fetchFeedUseCase: FetchFeedUseCase, changeLikeUseCase: ChangeLikeUseCase, followerID: String) {
        self.fetchFeedUseCase = fetchFeedUseCase
        self.changeLikeUseCase = changeLikeUseCase
        self.followerID = followerID
    }

    func transform(input: Input) -> Output {
        let fetchedNewPosts = Observable.merge(input.viewWillAppear, input.refresh)
            .withUnretained(self)
            .flatMapFirst { _ in
                return self.fetchFeedUseCase.fetchFollowPosts(
                    followerID: self.followerID,
                    startRange: .zero,
                    endRange: self.pageSize
                )
            }

        let fetchedMorePosts = input.lastCellDisplayed
            .flatMapFirst { posts in
                let lastCount = self.posts.value.count
                
                return self.fetchFeedUseCase.fetchFollowPosts(
                    followerID: self.followerID,
                    startRange: lastCount,
                    endRange: lastCount + self.pageSize - 1
                )
            }
            .map {
                let lastValue = self.posts.value
                return lastValue + $0
            }

        let updatedPosts = input.likeButtonTap
            .withUnretained(self)
            .flatMapFirst { _, postID in self.updatePosts(postID: postID) }

        let posts = Observable.merge(fetchedNewPosts, fetchedMorePosts, updatedPosts)
            .do { self.posts.accept($0) }
            .map { [PostSectionModel(title: UUID().uuidString, items: $0)] }

        return Output(posts: posts)
    }
}

private extension FeedViewModel {
    func updatePosts(postID: String) -> Observable<[Post]> {
        return toggleLike(postID: postID)
            .flatMap { postID, isLiked, likeCount in
                self.updatedPosts(postID: postID, isLiked: isLiked, likeCount: likeCount)
            }
    }

    func toggleLike(postID: String) -> Observable<(String, Bool, Int)> {
        return changeLikeUseCase.togglePostLike(postID: postID, userID: followerID)
            .andThen(Observable.zip(
                changeLikeUseCase.checkPostLiked(by: followerID, postID: postID),
                changeLikeUseCase.fetchPostLikeCount(postID: postID)
            ))
            .map { (isLiked, likeCount) in
                return (postID, isLiked, likeCount)
            }
    }

    func updatedPosts(postID: String, isLiked: Bool, likeCount: Int) -> Observable<[Post]> {
        var posts = self.posts.value
        guard let index = posts.firstIndex(where: { $0.postID == postID }) else { return .empty() }
        posts[index].isLiked = isLiked
        posts[index].likeCount = likeCount
        return .just(posts)
    }
}
