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
        let creatorQuery = SupabaseConstants.Constants.creatorEqual + userId
        let fanQuery = SupabaseConstants.Constants.fanEqual + userId
        
        return builder
            .set(method: .get)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Base.or: "(\(creatorQuery),\(fanQuery))"
            ])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey
            ])
            .build()
    }
    
    func requestCreateNewChat(_ chat: ChatDTO) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.path)
            .set(headers: [
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey
            ])
            .set(body: chat.toDictionary())
            .build()
    }
    
    func requestLeaveChat(chatId: String, userId: String, isCreator: Bool) -> URLRequest {
        let creatorId = SupabaseConstants.Constants.creatorId
        let fanId = SupabaseConstants.Constants.fanId
        let queryKey = isCreator ? creatorId : fanId
        return builder
            .set(method: .patch)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                queryKey: SupabaseConstants.Base.equal + userId
            ])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey
            ])
            .set(body: [queryKey: nil])
            .build()
    }
    
    func requestDeleteChatRoom(chatId: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.chatId: SupabaseConstants.Base.equal + chatId,
                SupabaseConstants.Constants.fanId: SupabaseConstants.Constants.isNull,
                SupabaseConstants.Constants.creatorId: SupabaseConstants.Constants.isNull
            ])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey
            ])
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        // BASE ELEMENT
        static let path = Base.basePath + "CHAT_ROOM"
        static let authKey = Base.authorization + Bundle.main.apiKey
        
        // QUERY KEY
        static let chatId = "chat_id"
        static let fanId = "fan_id"
        static let creatorId = "creator_id"
        static let null = "null"
        static let isNull = Base.is + null
        static let creatorEqual = creatorId + Base.equal
        static let fanEqual = fanId + Base.equal
    }
}
