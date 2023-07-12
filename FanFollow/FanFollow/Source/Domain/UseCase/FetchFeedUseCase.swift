//
//  FetchFeedUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/11.
//

import RxSwift

protocol FetchFeedUseCase: AnyObject {
    func fetchFollowPosts(followerID: String, startRange: Int, endRange: Int) -> Observable<[Post]>
}

final class DefaultFetchFeedUseCase: FetchFeedUseCase {
    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchFollowPosts(followerID: String, startRange: Int, endRange: Int) -> Observable<[Post]> {
        return postRepository
            .fetchFollowPosts(followerID: followerID, startRange: startRange, endRange: endRange)
            .map { postDTOs in
                postDTOs.map { Post($0) }
            }
    }
}
