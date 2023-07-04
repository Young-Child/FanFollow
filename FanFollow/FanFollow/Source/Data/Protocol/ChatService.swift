//
//  ChatService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol ChatService: SupabaseService {
    func fetchChattingList(userId: String) -> Observable<[ChatDTO]>
    func createNewChatRoom(_ chat: ChatDTO) -> Completable
    func leaveChatRoom(to chat: ChatDTO) -> Completable
    func deleteChatRoom(to chat: ChatDTO) -> Completable
}
