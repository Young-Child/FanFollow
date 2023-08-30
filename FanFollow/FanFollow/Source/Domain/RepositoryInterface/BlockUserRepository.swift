//
//  BlockUserRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

struct BanInformationDTO: Decodable {
    let userID: String
    let bannedID: String
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case bannedID = "ban_id"
        case createdDate = "created_at"
    }
}

protocol BlockUserRepository: SupabaseEndPoint {
    func fetchBlockUsers(to userID: String) -> Observable<[BanInformationDTO]>
    func deleteBlockUser(to banID: String) -> Completable
}
