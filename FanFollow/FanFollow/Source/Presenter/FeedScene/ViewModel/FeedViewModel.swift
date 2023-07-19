//
//  FeedViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/17.
//

import RxSwift
import RxRelay
import RxCocoa

final class FeedViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var refresh: Observable<Void>
        var lastCellDisplayed: Observable<Bool>
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
    private var isLoading = BehaviorRelay(value: false)

    private let posts = BehaviorRelay<[Post]>(value: [])

    init(fetchFeedUseCase: FetchFeedUseCase, changeLikeUseCase: ChangeLikeUseCase, followerID: String) {
        self.fetchFeedUseCase = fetchFeedUseCase
        self.changeLikeUseCase = changeLikeUseCase
        self.followerID = followerID
    }

    func transform(input: Input) -> Output {
        let newItems = Observable.merge(input.viewWillAppear, input.refresh)
            .debug()
            .flatMapLatest { [weak self] _ in
                guard let self else { return Observable<[Post]>.empty() }
                return self.fetchPosts(startIndex: 0)
            }.do { [weak self] newPosts in
                guard let self else { return }
                self.posts.accept(newPosts)
            }

        let newItems2 = Observable.combineLatest(
            isLoading.asObservable(),
            input.lastCellDisplayed
        ) { isLoading, lastCellDisplayed in
            return isLoading == false && lastCellDisplayed == true
        }
            .flatMapLatest { [weak self] _ in
                guard let self else { return Observable<[Post]>.empty() }
                return self.fetchPosts(startIndex: self.posts.value.count)
            }
            .map({ [weak self] newPosts in
                guard let self else { return [] }
                return newPosts + self.posts.value
            })

        let items = Observable.merge(newItems, newItems2)

        input.likeButtonTap
            .flatMapLatest { [weak self] postID in
                guard let self else { return Observable<(String, Bool, Int)>.empty() }
                return self.toggleLike(postID: postID)
            }
            .subscribe { [weak self] postID, isLiked, likeCount in
                guard let self else { return }
                self.updateLikeInfoInPosts(postID: postID, isLiked: isLiked, likeCount: likeCount)
            }
            .disposed(by: disposeBag)

        return Output(posts: items)
    }

    private func fetchPosts(startIndex: Int) -> Observable<[Post]> {
        let endRange = startIndex + pageSize - 1
        return fetchFeedUseCase.fetchFollowPosts(followerID: followerID, startRange: startIndex, endRange: endRange)
            .do { [weak self] _ in
                self?.isLoading.accept(false)
            }
    }

    private func toggleLike(postID: String) -> Observable<(String, Bool, Int)> {
        return changeLikeUseCase.togglePostLike(postID: postID, userID: followerID)
            .andThen(Observable.zip(
                    changeLikeUseCase.checkPostLiked(by: followerID, postID: postID),
                    changeLikeUseCase.fetchPostLikeCount(postID: postID)
            ))
            .map { (isLiked, likeCount) in
                return (postID, isLiked, likeCount)
            }
    }

    private func updateLikeInfoInPosts(postID: String, isLiked: Bool, likeCount: Int) {
        var posts = self.posts.value
        guard let index = posts.firstIndex(where: { $0.postID == postID }) else { return }
        posts[index].isLiked = isLiked
        posts[index].likeCount = likeCount
        self.posts.accept(posts)
    }
}
