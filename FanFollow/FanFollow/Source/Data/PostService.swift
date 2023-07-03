//
//  PostService.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation
import RxSwift

protocol PostService {
    func fetchPost() -> Observable<Data>
    
    func upsertPost(
        postID: String?,
        userID: String,
        title: String,
        description: String,
        imageURLs: [String],
        videoURL: String
    ) -> Completable
    
    func deletePost(postID: String) -> Completable
}

struct DefaultPostService: SupabaseService {
    private let disposeBag = DisposeBag()
    
    func fetchPost() {
        
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
        
        return NetworkManager().execute(request)
    }
    
    private func buildURL() -> URLRequestBuilder? {
        guard let url = URL(string: baseURL) else { return nil}
        
        return URLRequestBuilder(baseURL: url)
    }
}
