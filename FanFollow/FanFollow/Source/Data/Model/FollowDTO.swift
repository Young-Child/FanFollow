//
//  FollowDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation

struct FollowDTO: Decodable {
    let followID: String
    let followerID: String
    let followingID: String
    let createdDate: Date
    let userInformation: UserInformationDTO

    enum CodingKeys: String, CodingKey {
        case followID = "follow_id"
        case followerID = "follower_id"
        case followingID = "following_id"
        case createdDate = "created_at"
        case userInformation = "USER_INFORMATION"
    }
}
