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
    let createdData: String
    let title: String
    let content: String
    let imageURLs: [String]?
    let videoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case userID = "user_id"
        case createdData = "created_at"
        case imageURLs = "image_urls"
        case videoURL = "video_url"
        case title, content
    }
    
    func convertBody() -> [String: Any] {
        return [
            "post_id": postID ?? UUID().uuidString,
            "user_id": userID,
            "created_at": createdData,
            "title": title,
            "content": content,
            "image_urls": imageURLs as Any,
            "video_url": videoURL as Any
        ]
    }
}
