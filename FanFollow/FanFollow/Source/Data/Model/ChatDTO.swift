//
//  ChatDTO.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

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
