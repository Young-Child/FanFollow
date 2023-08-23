//
//  ProfileImagePickerViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

final class ProfileImagePickerViewModel: ViewModel {
    struct Input {
        var updateImage: Observable<Data?>
    }
    
    struct Output {
        var imageUploadResult: Observable<String>
    }
    
    var disposeBag = DisposeBag()
    private let profileImageUploadUseCase: UpdateProfileImageUseCase
    
    init(profileImageUploadUseCase: UpdateProfileImageUseCase) {
        self.profileImageUploadUseCase = profileImageUploadUseCase
    }
    
    func transform(input: Input) -> Output {
        let updateResult = input.updateImage
            .flatMap { imageData in
                return self.profileImageUploadUseCase.upsertProfileImage(with: imageData)
            }
        
        return Output(imageUploadResult: updateResult)
    }
}
