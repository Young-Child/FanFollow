//
//  FetchFeedUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/11.
//

import RxSwift
import Foundation

protocol FetchFeedUseCase: AnyObject {
    func fetchFollowPosts(startRange: Int, endRange: Int) -> Observable<[Post]>
}

final class DefaultFetchFeedUseCase: FetchFeedUseCase {
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    private let authRepository: AuthRepository

    init(postRepository: PostRepository, imageRepository: ImageRepository, authRepository: AuthRepository) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
        self.authRepository = authRepository
    }

    func fetchFollowPosts(startRange: Int, endRange: Int) -> Observable<[Post]> {
        let postDTOs = authRepository.storedSession()
            .flatMap { storedSession in
                let followerID = storedSession.userID
                return self.postRepository
                    .fetchFollowPosts(followerID: followerID, startRange: startRange, endRange: endRange)
            }

        let imageLinksUpdatedPost = postDTOs.flatMap { postDTOs -> Observable<[Post]> in
            let fetchImageURLs = postDTOs.compactMap(\.postID).map {
                return self.fetchPostImageLinks(postID: $0)
            }
            
            return Observable.zip(fetchImageURLs) { imageURLs -> [Post] in
                return zip(postDTOs, imageURLs).map { postDTO, imageURLs in
                    var post = Post(postDTO)
                    post.imageNames = imageURLs
                    return post
                }
            }
        }
        
        return imageLinksUpdatedPost
    }
    
    func fetchPostImageLinks(postID: String) -> Observable<[String]> {
        return imageRepository.readImageList(to: "PostImages", keyword: postID)
            .map { $0.map(\.name) }
    }
}
