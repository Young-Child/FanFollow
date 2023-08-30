//
//  DefaultBlockUserRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

final class DefaultBlockUserRepository: BlockUserRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchBlockUsers(to userID: String) -> Observable<[BanInformationDTO]> {
        let request = BlockUserDirector(builder: builder)
            .requestFetchBlockUsers(to: userID)
        
        return networkService.data(request)
            .decode(type: [BanInformationDTO].self, decoder: JSONDecoder())
    }
    
    func deleteBlockUser(to banID: String) -> Completable {
        let request = BlockUserDirector(builder: builder)
            .requestDeleteBlockUser(to: banID)
        
        return networkService.execute(request)
    }
}
