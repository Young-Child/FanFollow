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
    
    func fetchPostLikeCount(postID: String) -> Observable<Int> {
        let request = LikeRequestDirector(builder: builder)
            .requestUserLikeCount(postID: postID)

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
    
    func changePostLike(postID: String, userID: String) -> Completable {
        return checkUserPostLike(postID: postID, userID: userID)
            .flatMap { status in
                let director = LikeRequestDirector(builder: builder)
                var request = director.requestCreatePostLike(postID: postID, userID: userID)
                
                if status {
                    request = director.requestDeleteUserLike(postID: postID, userID: userID)
                }
                
                return networkManager.execute(request)
            }
            .ignoreElements()
            .asCompletable()
    }
    
    func checkUserPostLike(postID: String, userID: String) -> Observable<Bool> {
        let request = LikeRequestDirector(builder: builder)
            .requestUserLikeCount(postID: postID, userID: userID)
        
        return networkManager.data(request)
            .flatMap { data in
                guard let value = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                      let element = value.first?.first?.value as? Int
                else {
                    return Observable<Bool>.error(APIError.requestBuilderFailed)
                }
                
                return element == .zero ? Observable.just(false) : Observable.just(true)
            }
    }
}
