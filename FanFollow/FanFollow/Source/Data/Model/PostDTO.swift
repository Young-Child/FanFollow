//
//  PostDTO.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation

struct PostDTO: Decodable {
    let postID: String?
    let userID: String
    let createdDate: Date
    let title: String
    let content: String
    let imageURLs: [String]?
    let videoURL: String?
    let nickName: String?
    let profilePath: String?
    let isLiked: Bool?
    let likeCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case userID = "user_id"
        case createdDate = "created_at"
        case imageURLs = "image_urls"
        case videoURL = "video_url"
        case title, content
        case nickName = "nick_name"
        case profilePath = "profile_path"
        case isLiked = "is_liked"
        case likeCount = "like_count"
    }
    
    func convertBody() -> [String: Any] {
        return [
            "post_id": postID ?? UUID().uuidString,
            "user_id": userID,
            "title": title,
            "content": content,
            "image_urls": imageURLs as Any,
            "video_url": videoURL as Any
        ]
    }
}
