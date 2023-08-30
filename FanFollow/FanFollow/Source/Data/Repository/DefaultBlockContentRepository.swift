//
//  DefaultBlockContentRepository.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/30.
//

import Foundation

import RxSwift

final class DefaultBlockContentRepository: BlockContentRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func blockPost(_ postID: UUID, to userID: UUID) -> Completable {
        let request = BlockContentRequestDirector(builder: builder)
            .requestBlock(postID: postID, userID: userID)
        
        return networkService.execute(request)
    }
}
