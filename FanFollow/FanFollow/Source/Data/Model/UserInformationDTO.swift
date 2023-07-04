//
//  UserInformationDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

struct UserInformationDTO: Decodable {
    let userId: String
    let createdAt: String
    let isCreator: Bool
    let name: String
    let profilePath: String?
    let jobCategory: Int?
    let links: [String]?
    let introduce: String?
    let nickName: String

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case createdAt, isCreator, name, profilePath
        case jobCategory, links, introduce, nickName
    }
}
