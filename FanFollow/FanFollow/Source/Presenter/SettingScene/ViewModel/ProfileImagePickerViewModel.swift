//
//  ProfileImagePickerViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class ProfileImagePickerViewModel: ViewModel {
    struct Input {
        var updateImage: Observable<Void>
    }
    
    struct Output {
        var imageUploadResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output(imageUploadResult: .just(()))
    }
}
