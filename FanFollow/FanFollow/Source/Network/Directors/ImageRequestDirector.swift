//
//  ImageRequestBuilder.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ImageRequestDirector {
    private let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestImageData(path: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }
    
    func requestSaveImage(path: String, image: Data) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.png,
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Constants.xUpsert: true.description
            ])
            .set(body: .multipart(data: image))
            .setAccessKey()
            .build()
    }
    
    func deleteImage(path: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .delete)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .setAccessKey()
            .build()
    }
    
    func updateImage(path: String, image: Data) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + path)
            .set(method: .post)
            .set(headers: [
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.png,
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Constants.xUpsert: true.description
            ])
            .set(body: .multipart(data: image))
            .setAccessKey()
            .build()
    }
    
    func readImageList(path: String, keyword: String) -> URLRequest {
        return builder
            .set(path: SupabaseConstants.Constants.path + "list/" + path)
            .set(headers: [
                "Content-Type": "application/json",
                SupabaseConstants.Base.apikey: Bundle.main.apiKey
            ])
            .set(method: .post)
            .set(body: .json(values: ["prefix": keyword]))
            .setAccessKey()
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = "/storage/v1/object/"
        static let xUpsert = "x-upsert"
    }
}
