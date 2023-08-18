//
//  UploadViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import Foundation

import RxSwift
import Kingfisher

final class UploadViewModel: ViewModel {
    struct Input {
        var registerButtonTap: Observable<Upload>
    }
    
    struct Output {
        var post: Observable<Post?>
        var postImageDatas: Observable<[Data]>
        var registerResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let post: Post?
    private let uploadUseCase: UploadPostUseCase
    
    init(uploadUseCase: UploadPostUseCase, post: Post? = nil) {
        self.uploadUseCase = uploadUseCase
        self.post = post
        
        if let post = post {
            removePostImageInCacheStorage(with: post)
        }
    }
    
    func transform(input: Input) -> Output {
        let registerResult = input.registerButtonTap
            .flatMapLatest { uploadData in
                ImageCache.default.clearCache()
                return self.uploadUseCase
                    .upsertPost(uploadData, existPostID: self.post?.postID)
                    .andThen(Observable.just(()))
            }
        
        let postDatas = uploadUseCase.fetchPostImageDatas(
            self.post?.postID ?? "",
            imageCount: self.post?.imageURLs.count ?? .zero
        ).map { datas in
            return datas.sorted(by: { $0.0 < $1.0 })
                .map { $0.1 }
        }
        
        return Output(
            post: .just(self.post),
            postImageDatas: postDatas,
            registerResult: registerResult
        )
    }
    
    private func removePostImageInCacheStorage(with post: Post) {
        post.imageURLs.forEach {
            ImageCache.default.removeImageForKey(to: $0)
        }
    }
}
