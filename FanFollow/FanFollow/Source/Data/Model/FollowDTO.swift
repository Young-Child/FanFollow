//
//  FollowDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

struct FollowDTO: Decodable {
    let followId: Int
    let followerId: String
    let followingId: String
    let createdDate: String
    let userInformation: UserInformationDTO

    enum CodingKeys: String, CodingKey {
        case followId = "id"
        case followerId, followingId
        case createdDate = "createdAt"
        case userInformation = "UserInformation"
    }
}
