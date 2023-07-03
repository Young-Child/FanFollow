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
    
    let title: String
    let description: String
    
    let imageURLs: [String]
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case userID, title, description, imageURLs, videoURL
    }
    
    func convertBody() -> [String: Any] {
        return ["postId" : postID ?? UUID().uuidString,
                "userID" : userID,
                "title" : title,
                "description" : description,
                "imageURLs" : imageURLs,
                "videoURL" : videoURL
        ]
    }
}
