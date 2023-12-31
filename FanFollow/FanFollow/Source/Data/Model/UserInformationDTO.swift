//
//  UserInformationDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation

struct UserInformationDTO: Decodable {
    let userID: String
    let nickName: String
    let profilePath: String?
    let jobCategory: Int?
    let links: [String]?
    let introduce: String?
    let isCreator: Bool
    let createdDate: Date

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickName = "nick_name"
        case profilePath = "profile_path"
        case jobCategory = "job_category"
        case links = "links"
        case introduce = "introduce"
        case isCreator = "is_creator"
        case createdDate = "created_at"
    }

    func convertBody() -> [String: Any] {
        return [
            "user_id": userID,
            "nick_name": nickName,
            "profile_path": profilePath as Any,
            "job_category": jobCategory as Any,
            "links": links as Any,
            "introduce": introduce as Any,
            "is_creator": isCreator
        ]
    }
}
