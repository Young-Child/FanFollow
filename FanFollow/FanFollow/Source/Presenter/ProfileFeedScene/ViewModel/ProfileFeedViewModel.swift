//
//  ProfileFeedViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/27.
//

import RxSwift
import RxRelay

final class ProfileFeedViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var refresh: Observable<Void>
        var lastCellDisplayed: Observable<Void>
        var likeButtonTap: Observable<String>
        var followButtonTap: Observable<Void>
    }

    struct Output {
        var profileFeedSections: Observable<[ProfileFeedSectionModel]>
    }

    var disposeBag = DisposeBag()
    private let fetchCreatorPostUseCase: FetchCreatorPostsUseCase
    private let fetchCreatorInformationUseCase: FetchCreatorInformationUseCase
    private let changeLikeUseCase: ChangeLikeUseCase
    private let creatorID: String
    private let userID: String
    private let pageSize = 10

    private let posts = BehaviorRelay<[Post]>(value: [])
    private let creator = BehaviorRelay<Creator?>(value: nil)
    private let followerCount = BehaviorRelay<Int>(value: 0)
    private let isFollow = BehaviorRelay<Bool>(value: false)
    private let reachedLastPost = BehaviorRelay<Bool>(value: false)

    init(
        fetchCreatorPostUseCase: FetchCreatorPostsUseCase,
        fetchCreatorInformationUseCase: FetchCreatorInformationUseCase,
        changeLikeUseCase: ChangeLikeUseCase,
        creatorID: String,
        userID: String
    ) {
        self.fetchCreatorPostUseCase = fetchCreatorPostUseCase
        self.fetchCreatorInformationUseCase = fetchCreatorInformationUseCase
        self.changeLikeUseCase = changeLikeUseCase
        self.creatorID = creatorID
        self.userID = userID
    }

    func transform(input: Input) -> Output {
        let fetchedAll = Observable.merge(input.viewWillAppear, input.refresh)
            .withUnretained(self)
            .flatMapFirst { _ in
                return Observable.zip(
                    self.fetchNewPosts(),
                    self.fetchCreatorInformation(),
                    self.fetchFollowerCount(),
                    self.checkFollow()
                )
            }

        let fetchedMorePosts = input.lastCellDisplayed
            .withUnretained(self)
            .flatMapFirst { _ in self.fetchMorePosts() }
        
        let updatedPosts = input.likeButtonTap
            .withUnretained(self)
            .flatMapFirst { _, postID in self.updatePosts(postID: postID) }
        
        let updatedPostsAndProfile = Observable.merge(fetchedMorePosts, updatedPosts)
            .flatMap { posts -> Observable<([Post], Creator, Int, Bool)> in
                guard let creator = self.creator.value else { return .empty() }
                return .just((posts, creator, self.followerCount.value, self.isFollow.value))
            }

        let postsAndUpdatedProfile = input.followButtonTap
            .withUnretained(self)
            .flatMapFirst { _ in self.toggleFollow() }
            .flatMap { followerCount, isFollow -> Observable<([Post], Creator, Int, Bool)> in
                guard let creator = self.creator.value else { return .empty() }
                return .just((self.posts.value, creator, followerCount, isFollow))
            }

        let profileSections = profileSections(
            Observable.merge(fetchedAll, updatedPostsAndProfile, postsAndUpdatedProfile)
        )

        return Output(profileFeedSections: profileSections)
    }
}

private extension ProfileFeedViewModel {
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

    func fetchCreatorInformation() -> Observable<Creator> {
        return fetchCreatorInformationUseCase.fetchCreatorInformation(for: creatorID)
            .do { creator in self.creator.accept(creator) }
    }

    func fetchFollowerCount() -> Observable<Int> {
        return fetchCreatorInformationUseCase.fetchFollowerCount(for: creatorID)
            .do { followerCount in self.followerCount.accept(followerCount) }
    }

    func checkFollow() -> Observable<Bool> {
        return fetchCreatorInformationUseCase.checkFollow(creatorID: creatorID, userID: userID)
            .do { isFollow in self.isFollow.accept(isFollow) }
    }

    func toggleFollow() -> Observable<(Int, Bool)> {
        return fetchCreatorInformationUseCase.toggleFollow(creatorID: creatorID, userID: userID)
            .andThen(Observable.zip(
                fetchCreatorInformationUseCase.fetchFollowerCount(for: creatorID),
                fetchCreatorInformationUseCase.checkFollow(creatorID: creatorID, userID: userID)
            ))
            .do { followerCount, isFollow in
                self.followerCount.accept(followerCount)
                self.isFollow.accept(isFollow)
            }
    }

    func profileSections(_ observable: Observable<([Post], Creator, Int, Bool)>) -> Observable<[ProfileFeedSectionModel]> {
        return observable
            .map { posts, creator, followerCount, isFollow -> [ProfileFeedSectionModel] in
                return [
                    ProfileFeedSectionModel.profile(items: [
                        ProfileFeedSectionItem(creator: creator, followerCount: followerCount, isFollow: isFollow)
                    ]),
                    ProfileFeedSectionModel.posts(items: posts)
                ]
            }
    }
}
