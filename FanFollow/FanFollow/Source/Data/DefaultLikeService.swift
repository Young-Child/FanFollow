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
    
    func createPostLike(postID: String, userID: String) -> Completable {
        let request = LikeRequestDirector(builder: builder)
            .createPostLike(postID: postID, userID: userID)
        
        return networkManager.execute(request)
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
    
    // 게시물 좋아요를 취소한 경우
    func deleteUserPostLike(postID: String, userID: String) {
        // 유저와 포스트 모드 존재하면 삭제
    }
    
}
