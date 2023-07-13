//
//  FetchCreatorPostsUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol FetchCreatorPostsUseCase: AnyObject {
    func fetchCreatorPosts(creatorID: String, startRange: Int, endRange: Int) -> Observable<[Post]>
}

final class DefaultFetchCreatorPostsUseCase: FetchCreatorPostsUseCase {
    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchCreatorPosts(creatorID: String, startRange: Int, endRange: Int) -> Observable<[Post]> {
        return postRepository
            .fetchMyPosts(userID: creatorID, startRange: startRange, endRange: endRange)
            .map { postDTOs in
                postDTOs.map { Post($0) }
            }
    }
}
