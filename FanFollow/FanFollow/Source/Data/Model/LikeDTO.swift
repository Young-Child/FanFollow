//
//  LikeDTO.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

struct LikeDTO: Decodable {
    let postId: String
    let userId: String
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case postId
        case userId
        case createdDate = "createdAt"
    }
}
