//
//  DefaultImageRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

final class DefaultImageRepository: ImageRepository {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func uploadImage(to path: String, with image: Data) -> Completable {
        let request = ImageRequestDirector(builder: builder)
            .requestSaveImage(path: path, image: image)
        return network.execute(request)
    }
    
    func updateImage(to path: String, with image: Data) -> Completable {
        let request = ImageRequestDirector(builder: builder)
            .updateImage(path: path, image: image)
        return network.execute(request)
    }
    
    func deleteImage(to path: String) -> Completable {
        let request = ImageRequestDirector(builder: builder)
            .deleteImage(path: path)
        return network.execute(request)
    }
}
