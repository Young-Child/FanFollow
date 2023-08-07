//
//  UploadPostUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import Foundation

import RxSwift

protocol UploadPostUseCase: AnyObject {
    func uploadPost(_ upload: Upload, userID: String) -> Completable
}

final class DefaultUploadPostUseCase: UploadPostUseCase {
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()
    
    init(postRepository: PostRepository, imageRepository: ImageRepository) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
    }
    
    func uploadPost(_ upload: Upload, userID: String) -> Completable {
        let postID = UUID().uuidString.lowercased()

        if upload.videoURL == nil {
            return upsertPostWithImages(postID: postID, upload: upload, userID: userID)
        } else {
            return upsertPostWithVideo(postID: postID, upload: upload, userID: userID)
        }
    }
}

private extension DefaultUploadPostUseCase {
    func uploadImages(postID: String, imageDatas: [Data]) -> Observable<[Never]> {
        let results = Observable.from(imageDatas).enumerated()
            .flatMap { index, item in
                let path = "PostImages/\(postID)/\(index + 1).png"
                return self.imageRepository.uploadImage(to: path, with: item)
                    .asObservable()
            }
            .toArray()
            .asObservable()
        
        return results
    }

    func upsertPostWithImages(postID: String, upload: Upload, userID: String) -> Completable {
        return uploadImages(postID: postID, imageDatas: upload.imageDatas)
            .flatMap { _ in
                return self.postRepository.upsertPost(
                    postID: postID,
                    userID: userID,
                    createdDate: Date(),
                    title: upload.title,
                    content: upload.content,
                    imageURLs: [],
                    videoURL: nil
                )
            }
            .asCompletable()
    }

    func upsertPostWithVideo(postID: String, upload: Upload, userID: String) -> Completable {
        return self.postRepository.upsertPost(
            postID: postID,
            userID: userID,
            createdDate: Date(),
            title: upload.title,
            content: upload.content,
            imageURLs: [],
            videoURL: upload.videoURL
        )
    }
}
