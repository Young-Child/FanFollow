//
//  UpdateUserInformationUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol UpdateUserInformationUseCase: AnyObject {
    func updateUserInformation(
        userID: String,
        updateInformation: (image: Data?, nickName: String?, category: Int?, links: [String]?, introduce: String?)
    ) -> Observable<Void>
    
    func updateUserProfileImage(to userID: String, with image: Data?) -> Observable<Void>
}

final class DefaultUpdateUserInformationUseCase: UpdateUserInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    private let imageUpdateRepository: ImageRepository
    
    init(
        userInformationRepository: UserInformationRepository,
        imageUpdateRepository: ImageRepository
    ) {
        self.userInformationRepository = userInformationRepository
        self.imageUpdateRepository = imageUpdateRepository
    }
    
    func updateUserInformation(
        userID: String,
        updateInformation: (image: Data?, nickName: String?, category: Int?, links: [String]?, introduce: String?)
    ) -> Observable<Void> {
        return updateUserProfileImage(to: userID, with: updateInformation.image)
            .flatMapLatest { _ in
                return self.userInformationRepository.fetchUserInformation(for: userID)
            }
            .flatMapLatest { information in
                return self.userInformationRepository.upsertUserInformation(
                    userID: userID,
                    nickName: updateInformation.nickName ?? information.nickName,
                    profilePath: nil,
                    jobCategory: updateInformation.category ?? information.jobCategory,
                    links: updateInformation.links ?? information.links,
                    introduce: updateInformation.introduce ?? information.introduce,
                    isCreator: information.isCreator,
                    createdAt: information.createdAt
                )
                .andThen(Observable<Void>.just(()))
            }
    }
    
    func updateUserProfileImage(to userID: String, with image: Data?) -> Observable<Void> {
        guard let image = image else { return .just(()) }
        
        let path = "ProfileImage/\(userID)/profileImage.png"
        
        return imageUpdateRepository.updateImage(to: path, with: image)
            .andThen(.just(()))
            .catch { _ in
                return self.imageUpdateRepository.uploadImage(to: path, with: image)
                    .andThen(Observable<Void>.just(()))
            }
            .asObservable()
    }
}
