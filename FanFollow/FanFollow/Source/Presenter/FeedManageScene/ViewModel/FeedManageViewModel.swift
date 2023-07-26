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
        var feedManageSections: Observable<[FeedManageSectionModel]>
    }

    typealias CreatorInformation = (creator: Creator?, followerCount: Int)

    var disposeBag = DisposeBag()
    private let fetchCreatorPostUseCase: FetchCreatorPostsUseCase
    private let fetchCreatorInformationUseCase: FetchCreatorInformationUseCase
    private let changeLikeUseCase: ChangeLikeUseCase
    private let creatorID: String
    private let pageSize = 10

    private let posts = BehaviorRelay<[Post]>(value: [])
    private let creatorInformation = BehaviorRelay<CreatorInformation>(value: (nil, 0))
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
        let fetchedAll = Observable.merge(input.viewWillAppear, input.refresh)
            .withUnretained(self)
            .flatMapFirst { _ in return Observable.zip(self.fetchNewPosts(), self.fetchCreatorInformation()) }

        let fetchedMorePosts = input.lastCellDisplayed
            .withUnretained(self)
            .flatMapFirst { _ in self.fetchMorePosts() }
        let updatedPosts = input.likeButtonTap
            .withUnretained(self)
            .flatMapFirst { _, postID in self.updatePosts(postID: postID) }
        let postsAndCreatorInformation = Observable.merge(fetchedMorePosts, updatedPosts)
            .map { posts in (posts, self.creatorInformation.value) }

        let feedManageSections = feedManageSections(
            Observable.merge(fetchedAll, postsAndCreatorInformation)
        )

        return Output(feedManageSections: feedManageSections)
    }
}

private extension FeedManageViewModel {
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
        return fetchCreatorPostUseCase.fetchCreatorPosts(
            creatorID: creatorID,
            startRange: startIndex,
            endRange: endRange
        )
    }

    func updatePosts(postID: String) -> Observable<[Post]> {
        return toggleLike(postID: postID)
            .flatMap { postID, isLiked, likeCount in
                self.updatedPosts(postID: postID, isLiked: isLiked, likeCount: likeCount)
            }
            .do { updatedPosts in self.posts.accept(updatedPosts) }
    }

    func toggleLike(postID: String) -> Observable<(String, Bool, Int)> {
        return changeLikeUseCase.togglePostLike(postID: postID, userID: creatorID)
            .andThen(Observable.zip(
                changeLikeUseCase.checkPostLiked(by: creatorID, postID: postID),
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

    func fetchCreatorInformation() -> Observable<CreatorInformation> {
        return Observable.zip(
            self.fetchCreatorInformationUseCase.fetchCreatorInformation(for: self.creatorID),
            self.fetchCreatorInformationUseCase.fetchFollowerCount(for: self.creatorID)
        ).map {creator, followerCount in
            (creator: creator, followerCount: followerCount)
        }.do { creatorInformation in
            self.creatorInformation.accept(creatorInformation)
        }
    }

    func feedManageSections(
        _ observable: Observable<([Post], CreatorInformation)>
    ) -> Observable<[FeedManageSectionModel]> {
        return observable
            .flatMap { posts, creatorInformation -> Observable<[FeedManageSectionModel]> in
                guard let creator = creatorInformation.creator else { return .empty() }
                let followerCount = creatorInformation.followerCount
                let feedManageSections = [
                    FeedManageSectionModel.creatorInformation(
                        items: [CreatorInformationSectionItem(creator: creator, followerCount: followerCount)]
                    ),
                    FeedManageSectionModel.posts(items: posts)
                ]
                return Observable.just(feedManageSections)
            }
    }
}
