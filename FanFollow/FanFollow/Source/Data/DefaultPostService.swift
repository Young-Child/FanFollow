//
//  DefaultPostService.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation
import RxSwift

struct DefaultPostService: PostService {
    private let networkManager: Network
    
    init(networkManager: Network) {
        self.networkManager = networkManager
    }
    
    func fetchAllPost(startRange: Int, endRange: Int) -> Observable<[PostDTO]> {
        let range = String(startRange) + "-" + String(endRange)
        
        guard let builder = buildURL() else {
            return Observable.error(APIError.requestBuilderFailed)
        }
        
        let request = PostRequestDirector(builder: builder).requestGetPost(range: range)
        
        return networkManager.data(request)
            .compactMap { try? JSONDecoder().decode([PostDTO].self, from: $0) }
    }
    
    func upsertPost(
        postID: String? = nil,
        userID: String,
        title: String,
        description: String = "",
        imageURLs: [String] = [],
        videoURL: String = ""
    ) -> Completable {
        let postItem = PostDTO(
            postID: postID,
            userID: userID,
            title: title,
            description: description,
            imageURLs: imageURLs,
            videoURL: videoURL
        )
        
        guard let builder = buildURL() else {
            return Completable.error(APIError.requestBuilderFailed)
        }
        
        let request = PostRequestDirector(builder: builder).requestPostUpsert(item: postItem)
        
        return networkManager.execute(request)
    }
    
    func deletePost(postID: String) -> Completable {
        guard let builder = buildURL() else {
            return Completable.error(APIError.requestBuilderFailed)
        }
        
        let request = PostRequestDirector(builder: builder).requestDeletePost(postID: postID)
        
        return networkManager.execute(request)
    }
    
    private func buildURL() -> URLRequestBuilder? {
        guard let url = URL(string: baseURL) else { return nil }
        
        return URLRequestBuilder(baseURL: url)
    }
}
