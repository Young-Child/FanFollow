//
//  Post.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/11.
//

import Foundation
import Differentiator

struct Post {
    let postID: String?
    let userID: String
    let createdDate: Date
    let title: String
    let content: String
    let imageURLs: [String]?
    let videoURL: String?
    let nickName: String?
    let profilePath: String?
    var isLiked: Bool
    var likeCount: Int

    init(_ postDTO: PostDTO) {
        postID = postDTO.postID
        userID = postDTO.userID
        createdDate = postDTO.createdDate
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
    var createdDateDescription: String? {
        return createdDate.toString(format: "yyyy. MM. dd")
    }
}

extension Post: IdentifiableType {
    typealias Identity = String

    var identity: String {
        return postID ?? ""
    }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.identity == rhs.identity
    }
}
