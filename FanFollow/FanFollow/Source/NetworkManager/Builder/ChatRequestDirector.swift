//
//  ChatRequestDirector.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ChatDTO: Decodable {
    var chatId: String = UUID().uuidString
    var createdDate: String = Date().description
    let requestUserId: String?
    let creatorId: String?
    var isAccept: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case createdDate = "createdAt"
        case chatId, requestUserId, creatorId, isAccept
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "chatId": chatId,
            "requestUserId": requestUserId as Any,
            "creatorId": creatorId as Any,
            "isAccept": false
        ]
    }
}

struct ChatRequestDirector {
    let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder) {
        self.builder = builder
    }
    
    func requestChattingList(userId: String) -> URLRequest {
        return builder
            .set(method: .get)
            .set(path: "/rest/v1/Chat")
            .set(queryItems: ["or": "(creatorId.eq.\(userId),requestUserId.eq.\(userId))"])
            .set(headers: [
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .build()
    }
    
    func requestCreateNewChat(_ chat: ChatDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: "/rest/v1/Chat")
            .set(headers: [
                "Content-Type": "application/json",
                "apikey": Bundle.main.apiKey,
                "Authorization": "Bearer \(Bundle.main.apiKey)"
            ])
            .set(body: chat.toDictionary())
            .build()
    }
    
    func requestLeaveChat(chatId: String, userId: String, isCreator: Bool) -> URLRequest {
        let queryKey = isCreator ? "creatorId" : "requestUserId"
        return builder
            .set(method: .patch)
            .set(path: "/rest/v1/Chat")
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
}
