//
//  LikeDTO.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

struct LikeDTO: Decodable {
    let postID: String
    let userID: String
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case userID = "user_id"
        case createdDate = "created_at"
    }
}
