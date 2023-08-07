//
//  DefaultPostRepository.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation
import RxSwift

struct DefaultPostRepository: PostRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMyPosts(userID: String, startRange: Int, endRange: Int) -> Observable<[PostDTO]> {
        let request = PostRequestDirector(builder: builder)
            .requestMyPosts(userID: userID, startRange: startRange, endRange: endRange)
        
        return networkService.data(request)
            .compactMap { try? JSONDecoder.ISODecoder.decode([PostDTO].self, from: $0) }
    }

    func fetchFollowPosts(followerID: String, startRange: Int, endRange: Int) -> Observable<[PostDTO]> {
        let request = PostRequestDirector(builder: builder)
            .requestFollowPosts(followerID: followerID, startRange: startRange, endRange: endRange)

        return networkService.data(request)
            .compactMap { try? JSONDecoder.ISODecoder.decode([PostDTO].self, from: $0) }
    }

    func upsertPost(
        postID: String?,
        userID: String,
        createdDate: Date,
        title: String,
        content: String,
        imageURLs: [String]? = nil,
        videoURL: String?
    ) -> Completable {
        let postItem = PostDTO(
            postID: postID,
            userID: userID,
            createdDate: createdDate,
            title: title,
            content: content,
            imageURLs: imageURLs,
            videoURL: videoURL,
            nickName: nil,
            profilePath: nil,
            isLiked: nil,
            likeCount: nil
        )
        let request = PostRequestDirector(builder: builder).requestPostUpsert(item: postItem)
        
        return networkService.execute(request)
    }
    
    func deletePost(postID: String) -> Completable {
        let request = PostRequestDirector(builder: builder).requestDeletePost(postID: postID)
        
        return networkService.execute(request)
    }
}
