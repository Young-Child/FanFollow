//
//  UpdateProfileImageUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol UpdateProfileImageUseCase: AnyObject {
    func upsertProfileImage(with image: Data?) -> Observable<String>
}

final class DefaultUpdateProfileImageUseCase: UpdateProfileImageUseCase {
    private let imageRepository: ImageRepository
    private let authRepository: AuthRepository
    
    init(imageRepository: ImageRepository, authRepository: AuthRepository) {
        self.imageRepository = imageRepository
        self.authRepository = authRepository
    }
    
    func upsertProfileImage(with image: Data?) -> Observable<String> {
        guard let image = image else { return .error(APIError.requestBuilderFailed) }

        return authRepository.storedSession()
            .flatMap { storedSession -> Observable<String> in
                let userID = storedSession.userID
                let imagePath = "ProfileImage/\(userID)/profileImage.png"

                return self.imageRepository.updateImage(to: imagePath, with: image)
                    .catch { _ in
                        return self.imageRepository.uploadImage(to: imagePath, with: image)
                    }
                    .andThen(.just(()))
                    .map { _ in return userID }
            }
    }
}
