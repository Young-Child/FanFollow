//
//  FetchCreatorPostsUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/12.
//

import RxSwift

protocol FetchCreatorPostsUseCase: AnyObject {
    func fetchCreatorPosts(targetID: String, startRange: Int, endRange: Int) -> Observable<[Post]>
    func deletePost(post: Post, endRange: Int) -> Observable<[Post]>
}

final class DefaultFetchCreatorPostsUseCase: FetchCreatorPostsUseCase {
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    private let authRepository: AuthRepository

    init(
        postRepository: PostRepository,
        imageRepository: ImageRepository,
        authRepository: AuthRepository
    ) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
        self.authRepository = authRepository
    }

    func fetchCreatorPosts(targetID: String, startRange: Int, endRange: Int) -> Observable<[Post]> {
        let postDTOs = self.postRepository
            .fetchMyPosts(userID: targetID, startRange: startRange, endRange: endRange)
        
        let imageLinksUpdatedPost = postDTOs.flatMap { postDTOs -> Observable<[Post]> in
            if postDTOs.isEmpty { return .just([]) }
            
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
    
    func deletePost(post: Post, endRange: Int) -> Observable<[Post]> {
        return postRepository.deletePost(postID: post.postID ?? "")
            .andThen(Observable<Void>.just(()))
            .flatMap { _ in
                return self.fetchCreatorPosts(
                    targetID: post.userID,
                    startRange: .zero,
                    endRange: endRange
                )
            }
    }
    
    private func fetchPostImageLinks(postID: String) -> Observable<[String]> {
        return imageRepository.readImageList(to: "PostImages", keyword: postID)
            .map { $0.map(\.name) }
    }
}
