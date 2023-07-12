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
    var profilePath: String
    var isCreator: Bool = true
    
    var links: [String]
    var introduce: String
    var jobCategory: JobCategory

    init?(_ userInformationDTO: UserInformationDTO) {
        guard let jobCategoryNumber = userInformationDTO.jobCategory,
              let jobCategory = JobCategory(rawValue: jobCategoryNumber) else {
            return nil
        }

        self.id = userInformationDTO.userID
        self.nickName = userInformationDTO.nickName
        self.profilePath = userInformationDTO.profilePath ?? ""
        self.isCreator = userInformationDTO.isCreator
        self.links = userInformationDTO.links ?? []
        self.introduce = userInformationDTO.introduce ?? ""
        self.jobCategory = jobCategory
    }
}
