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
}
