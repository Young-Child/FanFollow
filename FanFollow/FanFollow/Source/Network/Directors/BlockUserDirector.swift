//
//  BlockUserDirector.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct BlockUserDirector {
    private let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestFetchBlockUserDirector(to userID: String) -> URLRequest {
        return builder
            .set(method: .get)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .set(queryItems: [
                SupabaseConstants.Constants.userID: userID
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let userID = "user_id"
    }
}
