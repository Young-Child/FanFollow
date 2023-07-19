//
//  Post.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/11.
//

import UIKit

struct Post {
    let postID: String?
    let userID: String
    let createdDateText: String
    let title: String
    let content: String
    let imageURLs: [String]?
    var images: [UIImage]?
    let videoURL: String?
    let nickName: String?
    let profilePath: String?
    var profileImage: UIImage?
    var isLiked: Bool
    var likeCount: Int

    init(_ postDTO: PostDTO) {
        postID = postDTO.postID
        userID = postDTO.userID
        createdDateText = postDTO.createdData
        title = postDTO.title
        content = postDTO.content
        imageURLs = postDTO.imageURLs
        videoURL = postDTO.videoURL
        nickName = postDTO.nickName
        profilePath = postDTO.profilePath
        isLiked = postDTO.isLiked ?? false
        likeCount = postDTO.likeCount ?? .zero
    }
}

extension Post {
    var createdDate: Date? {
        let dateFormatter = ISO8601DateFormatter().then { dateFormatter in
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        }
        return dateFormatter.date(from: createdDateText)
    }

    var formattedCreatedDate: String? {
        guard let createdDate else { return nil }
        let dateFormatter = DateFormatter().then { dateFormatter in
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        return dateFormatter.string(from: createdDate)
    }
}
