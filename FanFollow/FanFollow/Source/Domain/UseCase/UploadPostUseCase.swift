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
        content: String, imageURLs: [String], videoURL: String
    ) -> Completable
}

class DefaultUploadPostUseCase: UploadPostUseCase {
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func upsertPost(
        userID: String, title: String,
        content: String, imageURLs: [String],
        videoURL: String
    ) -> Completable {
        return postRepository.upsertPost(
            postID: nil,
            userID: userID,
            createdDate: Date(),
            title: title,
            content: content,
            imageURLs: imageURLs,
            videoURL: videoURL
        )
    }
}
