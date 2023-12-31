//
//  DefaultImageRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

struct SupabaseImageResource: Codable {
    let name: String
}

final class DefaultImageRepository: ImageRepository {
    private let network: NetworkService
    
    init(_ networkService: NetworkService) {
        self.network = networkService
    }
    
    func readImage(to path: String) -> Observable<Data> {
        let request = ImageRequestDirector(builder: builder)
            .requestImageData(path: path)
        return network.data(request)
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
    
    func readImageList(to path: String, keyword: String) -> Observable<[SupabaseImageResource]> {
        let request = ImageRequestDirector(builder: builder)
            .readImageList(path: path, keyword: keyword)
        return network.data(request)
            .decode(type: [SupabaseImageResource].self, decoder: JSONDecoder())
        
    }
}
