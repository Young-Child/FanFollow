//
//  UploadViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import RxSwift

final class UploadViewModel: ViewModel {
    struct Input {
        var registerButtonTap: Observable<Post>
    }
    
    struct Output {
        var registerResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let uploadUseCase: UploadPostUseCase
    
    init(uploadUseCase: UploadPostUseCase) {
        self.uploadUseCase = uploadUseCase
    }
    
    func transform(input: Input) -> Output {
        let registerResult = input.registerButtonTap
            .flatMapLatest { uploadData in
                return self.uploadUseCase
                    .upsertPost(
                        userID: uploadData.userID, title: uploadData.title,
                        content: uploadData.content, imageURLs: uploadData.imageURLs ?? [],
                        videoURL: uploadData.videoURL
                    )
                    .andThen(Observable.just(()))
            }
        
        return Output(registerResult: registerResult)
    }
}
