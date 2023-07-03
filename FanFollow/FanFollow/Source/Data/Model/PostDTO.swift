//
//  PostDTO.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation

struct PostDTO {
    let postID: String?
    let userID: String
    
    let title: String
    let description: String
    
    let imageURLs: [String]
    let videoURL: String
    
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
