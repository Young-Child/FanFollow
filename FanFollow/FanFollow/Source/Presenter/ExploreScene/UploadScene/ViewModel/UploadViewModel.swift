//
//  UploadViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import Foundation

import RxSwift

final class UploadViewModel: ViewModel {
    struct Input {
        var registerButtonTap: Observable<Upload>
    }
    
    struct Output {
        var post: Observable<Post?>
        var postDatas: Observable<[Data]>
        var registerResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let post: Post?
    private let uploadUseCase: UploadPostUseCase
    
    init(uploadUseCase: UploadPostUseCase, post: Post? = nil) {
        self.uploadUseCase = uploadUseCase
        self.post = post
    }
    
    func transform(input: Input) -> Output {
        let registerResult = input.registerButtonTap
            .flatMapLatest { uploadData in
                return self.uploadUseCase
                    .upsertPost(
                        uploadData,
                        userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                        existPostID: self.post?.postID
                    )
                    .andThen(Observable.just(()))
            }
        
        let postDatas = uploadUseCase.fetchPostImageDatas(
            self.post?.postID ?? "",
            imageCount: self.post?.imageURLs.count ?? .zero
        )
        
        return Output(
            post: .just(self.post),
            postDatas: postDatas,
            registerResult: registerResult
        )
    }
}
