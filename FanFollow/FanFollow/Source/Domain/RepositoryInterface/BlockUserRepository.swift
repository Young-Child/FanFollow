//
//  BlockUserRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol BlockUserRepository: SupabaseEndPoint {
    func fetchBlockUsers(to userID: String) -> Observable<[BanInformationDTO]>
    func deleteBlockUser(to banID: String) -> Completable
}
