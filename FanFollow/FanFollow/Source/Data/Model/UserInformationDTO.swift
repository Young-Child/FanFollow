//
//  UserInformationDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

struct UserInformationDTO: Decodable {
    let userID: String
    let createdAt: String
    let isCreator: Bool
    let name: String
    let profilePath: String?
    let jobCategory: Int?
    let links: [String]?
    let introduce: String?
    let nickName: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case createdAt = "created_at"
        case isCreator = "is_creator"
        case name = "name"
        case profilePath = "profile_path"
        case jobCategory = "job_category"
        case links = "links"
        case introduce = "introduce"
        case nickName = "nick_name"
    }
}
