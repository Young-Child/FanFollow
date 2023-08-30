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
    
    func requestFetchBlockUsers(to userID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
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
    
    func requestDeleteBlockUser(to bannedID: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path)
            .set(method: .delete)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .set(queryItems: [
                SupabaseConstants.Constants.banID: bannedID
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "BLOCK_USER"
        static let userID = "user_id"
        static let banID = "ban_id"
    }
}
