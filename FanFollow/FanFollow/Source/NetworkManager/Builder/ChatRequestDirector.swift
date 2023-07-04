//
//  ChatRequestDirector.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ChatRequestDirector {
    let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestChattingList(userId: String) -> URLRequest {
        return builder
            .set(method: .get)
            .set(path: "/rest/v1/CHAT_ROOM")
            .set(queryItems: ["or": "(creator_id.eq.\(userId),fan_id.eq.\(userId))"])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .build()
    }
    
    func requestCreateNewChat(_ chat: ChatDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: "/rest/v1/CHAT_ROOM")
            .set(headers: [
                "Content-Type": "application/json",
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .set(body: chat.toDictionary())
            .build()
    }
    
    func requestLeaveChat(chatId: String, userId: String, isCreator: Bool) -> URLRequest {
        let queryKey = isCreator ? "creator_id" : "fan_id"
        return builder
            .set(method: .patch)
            .set(path: "/rest/v1/CHAT_ROOM")
            .set(queryItems: [
                queryKey: "eq.\(userId)"
            ])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .set(body: [queryKey: nil])
            .build()
    }
    
    func requestDeleteChatRoom(chatId: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: "/rest/v1/CHAT_ROOM")
            .set(queryItems: [
                "chat_id": "eq.\(chatId)",
                "fan_id": "is.null",
                "creator_id": "is.null"
            ])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .build()
    }
}
