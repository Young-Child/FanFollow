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
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchAllPost(startRange: Int, endRange: Int) -> Observable<[PostDTO]> {
        let range = String(startRange) + "-" + String(endRange)
        let request = PostRequestDirector(builder: builder).requestGetPost(range: range)
        
        return networkService.data(request)
            .compactMap { try? JSONDecoder().decode([PostDTO].self, from: $0) }
    }
    
    func upsertPost(
        postID: String?,
        userID: String,
        createdDate: String,
        title: String,
        content: String,
        imageURLs: [String]?,
        videoURL: String?
    ) -> Completable {
        let postItem = PostDTO(
            postID: postID,
            userID: userID,
            createdData: createdDate,
            title: title,
            content: content,
            imageURLs: imageURLs,
            videoURL: videoURL
        )
        let request = PostRequestDirector(builder: builder).requestPostUpsert(item: postItem)
        
        return networkService.execute(request)
    }
    
    func deletePost(postID: String) -> Completable {
        let request = PostRequestDirector(builder: builder).requestDeletePost(postID: postID)
        
        return networkService.execute(request)
    }
}
