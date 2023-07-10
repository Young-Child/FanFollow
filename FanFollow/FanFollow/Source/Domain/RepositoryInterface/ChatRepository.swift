//
//  ChatRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

protocol ChatRepository: SupabaseEndPoint {
    func fetchChattingList(userID: String) -> Observable<[ChatDTO]>
    func createNewChatRoom(from fanID: String, to creatorID: String) -> Completable
    func leaveChatRoom(to chatID: String, userID: String, isCreator: Bool) -> Observable<Void>
    func deleteChatRoom(to chatID: String) -> Completable
}
