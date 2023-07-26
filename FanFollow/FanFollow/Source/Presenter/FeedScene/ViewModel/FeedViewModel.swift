//
//  FeedViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/17.
//

import RxSwift
import RxRelay

final class FeedViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var refresh: Observable<Void>
        var lastCellDisplayed: Observable<Void>
        var likeButtonTap: Observable<String>
    }

    struct Output {
        var posts: Observable<[Post]>
    }

    var disposeBag = DisposeBag()
    private let fetchFeedUseCase: FetchFeedUseCase
    private let changeLikeUseCase: ChangeLikeUseCase
    private let followerID: String
    private let pageSize = 10

    private let posts = BehaviorRelay<[Post]>(value: [])
    private let reachedLastPost = BehaviorRelay(value: false)

    init(fetchFeedUseCase: FetchFeedUseCase, changeLikeUseCase: ChangeLikeUseCase, followerID: String) {
        self.fetchFeedUseCase = fetchFeedUseCase
        self.changeLikeUseCase = changeLikeUseCase
        self.followerID = followerID
    }

    func transform(input: Input) -> Output {
        let fetchedNewPosts = Observable.merge(input.viewWillAppear, input.refresh)
            .withUnretained(self)
            .flatMapFirst { _ in self.fetchNewPosts() }

        let fetchedMorePosts = input.lastCellDisplayed
            .withUnretained(self)
            .flatMapFirst { _ in self.fetchMorePosts() }

        let updatedPosts = input.likeButtonTap
            .withUnretained(self)
            .flatMapFirst { _, postID in self.updatePosts(postID: postID) }

        let posts = Observable.merge(fetchedNewPosts, fetchedMorePosts, updatedPosts)

        return Output(posts: posts)
    }
}

private extension FeedViewModel {
    func fetchNewPosts() -> Observable<[Post]> {
        return fetchPosts(startIndex: 0)
            .do { fetchedPosts in
                let reachedLastPosts = fetchedPosts.count < self.pageSize
                self.reachedLastPost.accept(reachedLastPosts)

                self.posts.accept(fetchedPosts)
            }
    }

    func fetchMorePosts() -> Observable<[Post]> {
        let reachedLastPost = reachedLastPost.value
        guard reachedLastPost == false else { return .empty() }
        return fetchPosts(startIndex: posts.value.count)
            .flatMap { fetchedPosts -> Observable<[Post]> in
                guard fetchedPosts.isEmpty == false else {
                    self.reachedLastPost.accept(true)
                    return .empty()
                }

                let reachedLastPosts = fetchedPosts.count < self.pageSize
                self.reachedLastPost.accept(reachedLastPosts)

                let newPosts = self.posts.value + fetchedPosts
                self.posts.accept(newPosts)
                return .just(newPosts)
            }
    }

    func fetchPosts(startIndex: Int) -> Observable<[Post]> {
        let endRange = startIndex + pageSize - 1
        return fetchFeedUseCase.fetchFollowPosts(followerID: followerID, startRange: startIndex, endRange: endRange)
    }

    func updatePosts(postID: String) -> Observable<[Post]> {
        return toggleLike(postID: postID)
            .flatMap { postID, isLiked, likeCount in
                self.updatedPosts(postID: postID, isLiked: isLiked, likeCount: likeCount)
            }
            .do { updatedPosts in self.posts.accept(updatedPosts) }
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