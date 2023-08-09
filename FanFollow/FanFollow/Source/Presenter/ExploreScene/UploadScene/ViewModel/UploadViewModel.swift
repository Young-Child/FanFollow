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
                    .uploadPost(
                        uploadData,
                        userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
                    )
                    .andThen(Observable.just(()))
            }
        
        return Output(registerResult: registerResult)
    }
}
