//
//  Mock.swift
//  ServiceTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

@testable import FanFollow

protocol MockableType {
    static var data: Data { get }
}

extension ChatDTO: MockableType {
    static var data: Data {
        return """
        [{
            "chat_id": "3538b47a-1113-4aff-96d9-6e2ec4b37d46",
            "fan_id": "5b587434-438c-49d8-ae3c-88bb27a891d4",
            "creator_id": "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
            "is_accept": false,
            "created_at": "2023-07-04T08:50:01.824869+00:00"
        }]
        """.data(using: .utf8)!
    }
}

extension PostDTO: MockableType {
    static var data: Data {
        return """
        [{
                "post_id": "2936bffa-196f-4c87-92a6-121f7e83f24b",
                "user_id": "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                "created_at": "2023-07-05T00:53:40.940424+00:00",
                "title": "테스트1",
                "content": "테스트 컨텐츠1",
                "image_urls": null,
                "video_url": null
            },
            {
                "post_id": "aa1f8c34-9b26-4407-b323-691903226867",
                "user_id": "5b587434-438c-49d8-ae3c-88bb27a891d4",
                "created_at": "2023-07-05T01:46:27.693879+00:00",
                "title": "테스트2",
                "content": "테스트 컨텐츠2",
                "image_urls": null,
                "video_url": null
        }]
        """.data(using: .utf8)!
    }
}
