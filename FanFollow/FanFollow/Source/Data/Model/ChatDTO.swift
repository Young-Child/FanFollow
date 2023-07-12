//
//  ChatDTO.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ChatDTO: Decodable {
    var chatID: String = UUID().uuidString
    var isAccept: Bool = false
    var createdDate: String = Date().description
    let creatorID: String?
    let creatorNickName: String?
    let creatorProfilePath: String?
    let fanID: String?
    let fanNickName: String?
    let fanProfilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case createdDate = "created_at"
        case isAccept = "is_accept"
        case creatorID = "creator_id"
        case creatorNickName = "creator_nick_name"
        case creatorProfilePath = "creator_profile_path"
        case fanID = "fan_id"
        case fanNickName = "fan_nick_name"
        case fanProfilePath = "fan_profile_path"
    }
}
