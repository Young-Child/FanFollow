//
//  UpdateProfileImageUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol UpdateProfileImageUseCase: AnyObject {
    func upsertProfileImage(to userID: String, with image: Data?) -> Observable<Void>
}

class DefaultUpdateProfileImageUseCase: UpdateProfileImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func upsertProfileImage(to userID: String, with image: Data?) -> Observable<Void> {
        guard let image = image else {
            return .error(APIError.requestBuilderFailed)
        }
        let path = "ProfileImage/\(userID)/profileImage.png"
        return imageRepository.updateImage(to: path, with: image)
            .catch { _ in
                return self.imageRepository.uploadImage(to: path, with: image)
            }
            .andThen(.just(()))
    }
}
