//
//  UploadViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import RxSwift

final class UploadViewModel: ViewModel {
    struct Input {
        var registerButtonTap: Observable<Upload>
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
                        userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                        title: uploadData.title ?? "",
                        content: uploadData.content,
                        imageDatas: uploadData.imageDatas,
                        videoURL: uploadData.videoURL
                    )
                    .andThen(Observable.just(()))
            }
        
        return Output(registerResult: registerResult)
    }
}
