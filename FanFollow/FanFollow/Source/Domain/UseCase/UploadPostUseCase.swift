//
//  UploadPostUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import Foundation

import RxSwift

protocol UploadPostUseCase: AnyObject {
    func upsertPost(
        userID: String, title: String,
        content: String, imageDatas: [Data], videoURL: String?
    ) -> Completable
}

final class DefaultUploadPostUseCase: UploadPostUseCase {
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()
    
    init(postRepository: PostRepository, imageRepository: ImageRepository) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
    }
    
    func upsertPost(
        userID: String, title: String,
        content: String, imageDatas: [Data],
        videoURL: String?
    ) -> Completable {
        let postID = UUID().uuidString.lowercased()
        
        let results = Observable.from(imageDatas).enumerated()
            .flatMap { index, item in
                let path = "PostImages/\(postID)/\(index + 1).png"
                return self.imageRepository.uploadImage(to: path, with: item)
                    .asObservable()
            }
            .toArray()
            .asObservable()
            .flatMap { _ in
                return self.postRepository.upsertPost(
                    postID: postID,
                    userID: userID,
                    createdDate: Date(),
                    title: title,
                    content: content,
                    imageURLs: [],
                    videoURL: videoURL
                )
            }
        
        return results
            .asCompletable()
    }
}
