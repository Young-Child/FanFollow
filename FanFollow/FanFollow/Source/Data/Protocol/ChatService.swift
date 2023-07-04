//
//  ChatService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol ChatService: SupabaseService {
    func fetchChattingList(userId: String) -> Observable<[ChatDTO]>
    func createNewChatRoom(from fanId: String, to creatorId: String) -> Completable
    func leaveChatRoom(to chatId: String, id: String, isCreator: Bool) -> Observable<Void>
    func deleteChatRoom(to chatId: String) -> Completable
}
