//
//  DefaultLikeService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

struct DefaultLikeService: SupabaseService, LikeService {
    func fetchPostLike(id: String) -> Observable<[LikeDTO]> {
        guard let url = URL(string: baseURL) else {
            return Observable.error(APIError.requestBuilderFailed)
        }

        let builder = URLRequestBuilder(baseURL: url)
        let request = LikeRequestDirector(builder: builder)
            .requestUserLikeCount(id)

        return NetworkManager().data(request)
            .compactMap { try? JSONDecoder().decode([LikeDTO].self, from: $0) }
    }
}
