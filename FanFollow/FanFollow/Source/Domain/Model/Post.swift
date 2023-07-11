//
//  Post.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/11.
//

struct Post {
    let postID: String?
    let userID: String
    let createdData: String
    let title: String
    let content: String
    let imageURLs: [String]?
    let videoURL: String?
    let nickName: String?
    let profilePath: String?

    init(_ postDTO: PostDTO) {
        postID = postDTO.postID
        userID = postDTO.userID
        createdData = postDTO.createdData
        title = postDTO.title
        content = postDTO.content
        imageURLs = postDTO.imageURLs
        videoURL = postDTO.videoURL
        nickName = postDTO.nickName
        profilePath = postDTO.profilePath
    }
}
