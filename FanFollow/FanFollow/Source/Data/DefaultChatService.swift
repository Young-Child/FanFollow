//
//  DefaultChatService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

struct DefaultChatService: ChatService {
    private let networkManager: Network
    
    init(networkManager: Network) {
        self.networkManager = networkManager
    }
    
    func fetchChattingList(userId: String) -> Observable<[ChatDTO]> {
        let request = ChatRequestDirector(builder: builder)
            .requestChattingList(userId: userId)
        
        return networkManager.data(request)
            .compactMap { try JSONDecoder().decode([ChatDTO].self, from: $0) }
    }
    
    func createNewChatRoom(from userId: String, to creatorId: String) -> Completable {
        let newChatRoom = ChatDTO(requestUserId: userId, creatorId: creatorId)
        let request = ChatRequestDirector(builder: builder)
            .requestCreateNewChat(newChatRoom)
        
        return networkManager.execute(request)
    }
    
    func leaveChatRoom(to chatId: String, id: String, isCreator: Bool) -> Observable<Void> {
        let request = ChatRequestDirector(builder: builder)
            .requestLeaveChat(chatId: chatId, userId: id, isCreator: isCreator)
        
        return networkManager.data(request).map { _ in return }
    }
    
    func deleteChatRoom(to chatId: String) -> Completable {
        let request = ChatRequestDirector(builder: builder)
            .requestDeleteChatRoom(chatId: chatId)
        
        return networkManager.execute(request)
    }
}
