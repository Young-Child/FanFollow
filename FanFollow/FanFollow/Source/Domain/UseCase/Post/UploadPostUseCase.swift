//
//  UploadPostUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import Foundation

import RxSwift
import Kingfisher

protocol UploadPostUseCase: AnyObject {
    func upsertPost(_ upload: Upload, existPostID: String?) -> Observable<String>
    func fetchPostImageDatas(_ postID: String) -> Observable<[(String, Data)]>
}

final class DefaultUploadPostUseCase: UploadPostUseCase {
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    init(
        postRepository: PostRepository,
        imageRepository: ImageRepository,
        authRepository: AuthRepository
    ) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
        self.authRepository = authRepository
    }
    
    func upsertPost(_ upload: Upload, existPostID: String? = nil) -> Observable<String> {
        var postID = UUID().uuidString.lowercased()
        let result: Completable
        
        if let existPostID = existPostID {
            postID = existPostID
        }
        
        if upload.videoURL == nil {
            result = uploadImages(postID: postID, imageDatas: upload.imageDatas)
                .asObservable()
                .flatMap { _ in
                    return self.upsertPost(
                        postID: postID,
                        createdDate: Date(),
                        title: upload.title,
                        content: upload.content,
                        imageURLs: [],
                        videoURL: nil
                    )
                }
                .asCompletable()
        } else {
            result = self.upsertPost(
                postID: postID,
                createdDate: Date(),
                title: upload.title,
                content: upload.content,
                imageURLs: [],
                videoURL: upload.videoURL
            )
        }
        
        return result
            .andThen(Observable<String>.just(postID))
    }
    
    private func upsertPost(
        postID: String?,
        createdDate: Date,
        title: String,
        content: String,
        imageURLs: [String]?,
        videoURL: String?
    ) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.postRepository.upsertPost(
                    postID: postID,
                    userID: userID,
                    createdDate: createdDate,
                    title: title,
                    content: content,
                    imageURLs: imageURLs,
                    videoURL: videoURL
                )
                .asObservable()
            }
            .asCompletable()
    }
    
    func fetchPostImageDatas(_ postID: String) -> Observable<[(String, Data)]> {
        fetchImagePaths(postID: postID)
            .flatMap { paths in
                return Observable.from(paths)
                    .flatMap { path in
                        let imagePath = "PostImages/\(postID)/\(path)"
                        return self.imageRepository.readImage(to: imagePath)
                            .map { (imagePath, $0) }
                    }
            }
            .toArray()
            .asObservable()
    }
    
    private func fetchImagePaths(postID: String) -> Observable<[String]> {
        return self.imageRepository.readImageList(to: "PostImages", keyword: postID)
            .map { $0.map { $0.name } }
    }
    
    private func uploadImages(postID: String, imageDatas: [Data]) -> Observable<Void> {
        return fetchImagePaths(postID: postID).flatMap { paths in
            return Observable.from(paths)
                .flatMap { path in
                    let imagePath = "PostImages/\(postID)/\(path)"
                    return self.imageRepository.deleteImage(to: imagePath)
                }
        }
        .asCompletable()
        .andThen(Observable<Void>.just(()))
        .concatMap { _ in
            return Observable.from(imageDatas.enumerated())
                .flatMap { index, data in
                    let path = "PostImages/\(postID)/\(index + 1).png"
                    return self.imageRepository.uploadImage(to: path, with: data)
                }
        }
        .asCompletable()
        .andThen(Observable<Void>.just(()))
    }
}
