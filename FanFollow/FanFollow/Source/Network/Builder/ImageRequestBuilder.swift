//
//  ImageRequestBuilder.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ImageRequestBuilder {
    private let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestSaveImage(path: String, image: Data) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey
            ])
            .set(body: .multipart(data: image))
            .build()
    }
    
    func requestImage(path: String) -> URL? {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .get)
            .build()
            .url
    }
    
    func deleteImage(path: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .delete)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey
            ])
            .build()
    }
    
    func updateImage(path: String, image: Data) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .put)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Base.bearer + Bundle.main.apiKey
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = "/storage/v1/object/"
    }
}
