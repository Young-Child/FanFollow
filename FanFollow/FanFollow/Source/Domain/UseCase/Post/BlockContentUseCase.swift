//
//  BlockContentUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/30.
//

import Foundation

import RxSwift

protocol BlockContentUseCase: AnyObject {
    func block(postID: UUID, to userID: UUID) -> Completable
}

final class DefaultBlockContentUseCase: BlockContentUseCase {
    private let blockContentRepository: BlockContentRepository
    
    init(blockContentRepository: BlockContentRepository) {
        self.blockContentRepository = blockContentRepository
    }
    
    func block(postID: UUID, to userID: UUID) -> Completable {
        return blockContentRepository.blockPost(postID, to: userID)
    }
}
