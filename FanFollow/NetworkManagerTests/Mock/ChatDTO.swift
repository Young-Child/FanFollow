//
//  ChatDTO.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

@testable import FanFollow

extension ChatDTO: Mockable {
    var mock: [ChatDTO] {
        return [
            .init(chatID: "1", fanId: "fanID", creatorId: "creatorID"),
            .init(chatID: "2", fanId: "fanID", creatorId: "creatorID"),
        ]
    }
    
    var data: Data {
        return """
        [
            {
                "chat_id": "3538b47a-1113-4aff-96d9-6e2ec4b37d46",
                "fan_id": "5b587434-438c-49d8-ae3c-88bb27a891d4",
                "creator_id": "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                "is_accept": false,
                "created_at": "2023-07-04T08:50:01.824869+00:00"
            }
        ]
        """.data(using: .utf8)!
    }
}
