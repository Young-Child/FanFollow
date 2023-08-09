//
//  AuthRequestDirector.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/07.
//

import Foundation

struct AuthRequestDirector {
    private let builder: URLRequestBuilder

    init(builder: URLRequestBuilder) {
        self.builder = builder
    }

    func requestSignIn(with idToken: String, of provider: Provider) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.tokenPath)
            .set(queryItems: [
                SupabaseConstants.Constants.grantType: SupabaseConstants.Constants.idToken
            ])
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Constants.accept: SupabaseConstants.Base.json,
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .set(body: [
                SupabaseConstants.Constants.idToken: idToken,
                SupabaseConstants.Constants.provider: provider.rawValue
            ])
            .build()
    }

    func requestRefreshSession(with refreshToken: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.tokenPath)
            .set(queryItems: [
                SupabaseConstants.Constants.grantType: SupabaseConstants.Constants.refreshToken
            ])
            .set(method: .post)
            .set(body: [
                SupabaseConstants.Constants.refreshToken: refreshToken
            ])
            .build()
    }

    func requestSignOut(with accessToken: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.logoutPath)
            .set(headers: [
                SupabaseConstants.Constants.accept: SupabaseConstants.Base.json,
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .set(method: .post)
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let tokenPath = "/auth/v1/token"
        static let logoutPath = "/auth/v1/logout"
        static let grantType = "grant_type"
        static let idToken = "id_token"
        static let refreshToken = "refresh_token"
        static let accept = "Accept"
        static let provider = "provider"
    }
}


