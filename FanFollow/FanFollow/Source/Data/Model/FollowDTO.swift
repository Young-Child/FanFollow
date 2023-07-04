//
//  FollowDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

struct FollowDTO: Decodable {
    let followId: String
    let followerId: String
    let followingId: String
    let createdDate: String
    let userInformation: UserInformationDTO

    enum CodingKeys: String, CodingKey {
        case followId = "follow_id"
        case followerId = "follower_id"
        case followingId = "following_id"
        case createdDate = "created_at"
        case userInformation = "USER_INFORMATION"
    }
}
