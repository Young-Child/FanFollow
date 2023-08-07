//
//  UploadPostUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import Foundation

import RxSwift

protocol UploadPostUseCase: AnyObject {
    func upsertPost(_ upload: Upload, userID: String, existPostID: String?) -> Completable
    func fetchPostImageDatas(_ postID: String, imageCount: Int) -> Observable<[Data]>
}

final class DefaultUploadPostUseCase: UploadPostUseCase {
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()
    
    init(postRepository: PostRepository, imageRepository: ImageRepository) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
    }
    
    private func uploadImages(postID: String, imageDatas: [Data]) -> Observable<[Never]> {
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
    
    func upsertPost(_ upload: Upload, userID: String, existPostID: String? = nil) -> Completable {
        var postID = UUID().uuidString.lowercased()
        let result: Completable
        
        if let existPostID = existPostID {
            postID = existPostID
        }
        
        if upload.videoURL == nil {
            result = uploadImages(postID: postID, imageDatas: upload.imageDatas)
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
        } else {
            result = self.postRepository.upsertPost(
                postID: postID,
                userID: userID,
                createdDate: Date(),
                title: upload.title,
                content: upload.content,
                imageURLs: [],
                videoURL: upload.videoURL
            )
        }
        
        return result
    }
    
    func fetchPostImageDatas(_ postID: String, imageCount: Int) -> Observable<[Data]> {
        return Observable.from(0..<imageCount)
            .flatMap { postImageID in
                let path = "PostImages/\(postID)/\(postImageID + 1).png"
                return self.imageRepository.readImage(to: path)
            }
            .toArray()
            .asObservable()
    }
}
