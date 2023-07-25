//
//  FeedManageViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/25.
//

import RxSwift
import RxRelay

final class FeedManageViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var refresh: Observable<Void>
        var lastCellDisplayed: Observable<Void>
        var likeButtonTap: Observable<String>
    }

    struct Output {
        var posts: Observable<[Post]>
        var creatorInformation: Observable<(Creator, Int)>
    }

    var disposeBag = DisposeBag()
    private let fetchCreatorPostUseCase: FetchCreatorPostsUseCase
    private let fetchCreatorInformationUseCase: FetchCreatorInformationUseCase
    private let changeLikeUseCase: ChangeLikeUseCase
    private let creatorID: String
    private let pageSize = 10

    private let posts = BehaviorRelay<[Post]>(value: [])
    private let reachedLastPost = BehaviorRelay(value: false)

    init(
        fetchCreatorPostUseCase: FetchCreatorPostsUseCase,
        fetchCreatorInformationUseCase: FetchCreatorInformationUseCase,
        changeLikeUseCase: ChangeLikeUseCase,
        creatorID: String
    ) {
        self.fetchCreatorPostUseCase = fetchCreatorPostUseCase
        self.fetchCreatorInformationUseCase = fetchCreatorInformationUseCase
        self.changeLikeUseCase = changeLikeUseCase
        self.creatorID = creatorID
    }

    func transform(input: Input) -> Output {
        let fetchedNewPosts = Observable.merge(input.viewWillAppear, input.refresh)
            .withUnretained(self)
            .flatMapFirst { _ in self.fetchPosts(startIndex: 0) }
            .do { fetchedPosts in
                let reachedLastPosts = fetchedPosts.count < self.pageSize
                self.reachedLastPost.accept(reachedLastPosts)

                self.posts.accept(fetchedPosts)
            }

        let fetchedMorePosts = input.lastCellDisplayed
            .withUnretained(self)
            .flatMapFirst { _ -> Observable<[Post]> in
                let reachedLastPost = self.reachedLastPost.value
                return reachedLastPost ? .empty() : self.fetchPosts(startIndex: self.posts.value.count)
            }
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

        let updatedPosts = input.likeButtonTap
            .withUnretained(self)
            .flatMapFirst { _, postID in self.toggleLike(postID: postID) }
            .flatMap { postID, isLiked, likeCount in
                self.updatedPosts(postID: postID, isLiked: isLiked, likeCount: likeCount)
            }
            .do { updatedPosts in self.posts.accept(updatedPosts) }

        let creatorInformation = input.viewWillAppear
            .withUnretained(self)
            .flatMapFirst { _ in
                Observable.zip(
                    self.fetchCreatorInformationUseCase.fetchCreatorInformation(for: self.creatorID),
                    self.fetchCreatorInformationUseCase.fetchFollowerCount(for: self.creatorID)
                )
            }

        let posts = Observable.merge(fetchedNewPosts, fetchedMorePosts, updatedPosts)

        return Output(posts: posts, creatorInformation: creatorInformation)
    }

    private func fetchPosts(startIndex: Int) -> Observable<[Post]> {
        let endRange = startIndex + pageSize - 1
        return fetchCreatorPostUseCase.fetchCreatorPosts(creatorID: creatorID, startRange: startIndex, endRange: endRange)
    }

    private func toggleLike(postID: String) -> Observable<(String, Bool, Int)> {
        return changeLikeUseCase.togglePostLike(postID: postID, userID: creatorID)
            .andThen(Observable.zip(
                changeLikeUseCase.checkPostLiked(by: creatorID, postID: postID),
                changeLikeUseCase.fetchPostLikeCount(postID: postID)
            ))
            .map { (isLiked, likeCount) in
                return (postID, isLiked, likeCount)
            }
    }

    private func updatedPosts(postID: String, isLiked: Bool, likeCount: Int) -> Observable<[Post]> {
        var posts = self.posts.value
        guard let index = posts.firstIndex(where: { $0.postID == postID }) else { return .empty() }
        posts[index].isLiked = isLiked
        posts[index].likeCount = likeCount
        return .just(posts)
    }
}
