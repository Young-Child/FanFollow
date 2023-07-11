//
//  ChatDTO.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ChatDTO: Decodable {
    var chatID: String = UUID().uuidString
    var createdDate: String = Date().description
    let fanID: String?
    let creatorID: String?
    var isAccept: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdDate = "created_at"
        case fanID = "fan_id"
        case creatorID = "creator_id"
        case isAccept = "is_accept"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "chat_id": chatID,
            "fan_id": fanID as Any,
            "creator_id": creatorID as Any,
            "is_accept": false
        ]
    }
}
