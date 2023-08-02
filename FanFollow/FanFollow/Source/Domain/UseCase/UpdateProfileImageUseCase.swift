//
//  UpdateProfileImageUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol UpdateProfileImageUseCase: AnyObject {
    func upsertProfileImage(to userID: String, with image: Data?) -> Observable<String>
}

final class DefaultUpdateProfileImageUseCase: UpdateProfileImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func upsertProfileImage(to userID: String, with image: Data?) -> Observable<String> {
        guard let image = image else { return .error(APIError.requestBuilderFailed) }
        
        let imagePath = "ProfileImage/\(userID)/profileImage.png"
        
        return imageRepository.updateImage(to: imagePath, with: image)
            .catch { _ in
                return self.imageRepository.uploadImage(to: imagePath, with: image)
            }
            .andThen(.just(()))
            .map { _ in return userID }
    }
}
