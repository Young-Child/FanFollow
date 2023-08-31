//
//  BlockContentUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/30.
//

import Foundation

import RxSwift

protocol BlockContentUseCase: AnyObject {
    func block(postID: String) -> Completable
}

final class DefaultBlockContentUseCase: BlockContentUseCase {
    private let blockContentRepository: BlockContentRepository
    private let authRepository: AuthRepository
    
    init(blockContentRepository: BlockContentRepository, authRepository: AuthRepository) {
        self.blockContentRepository = blockContentRepository
        self.authRepository = authRepository
    }
    
    func block(postID: String) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.blockContentRepository.blockPost(postID, to: userID)
                    .asObservable()
            }
            .asCompletable()
    }
}
