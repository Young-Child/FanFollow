//
//  Creator.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation

struct Creator: User {
    var id: String
    var nickName: String
    var isCreator: Bool = true
    
    var links: [String]?
    var introduce: String?
    var jobCategory: JobCategory?
    
    init(_ userInformationDTO: UserInformationDTO) {
        id = userInformationDTO.userID
        nickName = userInformationDTO.nickName
        links = userInformationDTO.links
        introduce = userInformationDTO.introduce
        jobCategory = JobCategory(
            rawValue: userInformationDTO.jobCategory ?? JobCategory.unSetting.rawValue
        )
        isCreator = userInformationDTO.isCreator
    }
}
