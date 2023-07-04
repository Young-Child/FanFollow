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
    
    func fetchChattingList(userID: String) -> Observable<[ChatDTO]> {
        let request = ChatRequestDirector(builder: builder)
            .requestChattingList(userId: userID)
        
        return networkManager.data(request)
            .compactMap { try JSONDecoder().decode([ChatDTO].self, from: $0) }
    }
    
    func createNewChatRoom(from fanID: String, to creatorID: String) -> Completable {
        let newChatRoom = ChatDTO(fanId: fanID, creatorId: creatorID)
        let request = ChatRequestDirector(builder: builder)
            .requestCreateNewChat(newChatRoom)
        
        return networkManager.execute(request)
    }
    
    func leaveChatRoom(to chatID: String, userID: String, isCreator: Bool) -> Observable<Void> {
        let request = ChatRequestDirector(builder: builder)
            .requestLeaveChat(chatId: chatID, userId: userID, isCreator: isCreator)
        
        return networkManager.data(request).map { _ in return }
    }
    
    func deleteChatRoom(to chatID: String) -> Completable {
        let request = ChatRequestDirector(builder: builder)
            .requestDeleteChatRoom(chatId: chatID)
        
        return networkManager.execute(request)
    }
}
