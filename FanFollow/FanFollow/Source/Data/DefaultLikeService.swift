//
//  DefaultLikeService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

struct DefaultLikeService: LikeService {
    private let networkManager: Network
    
    init(networkManager: Network) {
        self.networkManager = networkManager
    }
    
    func fetchPostLikeCount(postID: String, userID: String? = nil) -> Observable<Int> {
        let request = LikeRequestDirector(builder: builder)
            .requestUserLikeCount(postID: postID, userID: userID)

        return networkManager.data(request)
            .flatMap { data in
                guard let value = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                      let element = value.first?.first?.value as? Int
                else {
                    return Observable<Int>.error(APIError.requestBuilderFailed)
                }
                
                return Observable.just(element)
            }
    }
    
    func createPostLike(postID: String, userID: String) -> Completable {
        let request = LikeRequestDirector(builder: builder)
            .requestCreatePostLike(postID: postID, userID: userID)
        
        return networkManager.execute(request)
    }
    
    func deletePostLike(postID: String, userID: String) -> Completable {
        let request = LikeRequestDirector(builder: builder)
            .requestDeleteUserLike(postID: postID, userID: userID)
        
        return networkManager.execute(request)
    }
}
