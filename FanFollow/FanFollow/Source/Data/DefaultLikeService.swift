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
    
    func fetchPostLike(postId: String) -> Observable<[LikeDTO]> {
        guard let url = URL(string: baseURL) else {
            return Observable.error(APIError.requestBuilderFailed)
        }

        let builder = URLRequestBuilder(baseURL: url)
        let request = LikeRequestDirector(builder: builder)
            .requestUserLikeCount(postId)

        return networkManager.data(request)
            .compactMap { try? JSONDecoder().decode([LikeDTO].self, from: $0) }
    }
}
