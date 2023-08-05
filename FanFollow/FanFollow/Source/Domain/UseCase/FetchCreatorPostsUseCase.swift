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
    private let imageRepository: ImageRepository

    init(
        postRepository: PostRepository,
        imageRepository: ImageRepository
    ) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
    }

    func fetchCreatorPosts(creatorID: String, startRange: Int, endRange: Int) -> Observable<[Post]> {
        let postDTOs = postRepository
            .fetchMyPosts(userID: creatorID, startRange: startRange, endRange: endRange)
        
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
    
    private func fetchPostImageLinks(postID: String) -> Observable<[String]> {
        return imageRepository.readImageList(to: "PostImages", keyword: postID)
            .map { $0.map(\.name) }
    }
}
