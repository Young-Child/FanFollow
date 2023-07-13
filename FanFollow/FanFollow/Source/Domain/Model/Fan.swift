//
//  Fan.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation

struct Fan: User {
    var id: String
    var nickName: String
    var profilePath: String?
    var isCreator: Bool = false

    init(_ userInformationDTO: UserInformationDTO) {
        self.id = userInformationDTO.userID
        self.nickName = userInformationDTO.nickName
        self.profilePath = userInformationDTO.profilePath ?? ""
        self.isCreator = userInformationDTO.isCreator
    }
}