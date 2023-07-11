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
    
    func requestChattingList(userID: String) -> URLRequest {
        let creatorQuery = SupabaseConstants.Constants.creatorEqual + userID
        let fanQuery = SupabaseConstants.Constants.fanEqual + userID
        
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
    
    func requestLeaveChat(chatID: String, userID: String, isCreator: Bool) -> URLRequest {
        let creatorID = SupabaseConstants.Constants.creatorID
        let fanID = SupabaseConstants.Constants.fanID
        let queryKey = isCreator ? creatorID : fanID
        return builder
            .set(method: .patch)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                queryKey: SupabaseConstants.Base.equal + userID
            ])
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.authorization: SupabaseConstants.Constants.authKey
            ])
            .set(body: [queryKey: nil])
            .build()
    }
    
    func requestDeleteChatRoom(chatID: String) -> URLRequest {
        return builder
            .set(method: .delete)
            .set(path: SupabaseConstants.Constants.path)
            .set(queryItems: [
                SupabaseConstants.Constants.chatID: SupabaseConstants.Base.equal + chatID,
                SupabaseConstants.Constants.fanID: SupabaseConstants.Constants.isNull,
                SupabaseConstants.Constants.creatorID: SupabaseConstants.Constants.isNull
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
        static let chatID = "chat_id"
        static let fanID = "fan_id"
        static let creatorID = "creator_id"
        static let null = "null"
        static let isNull = Base.is + null
        static let creatorEqual = creatorID + Base.equal
        static let fanEqual = fanID + Base.equal
    }
}
