//
//  ExploreSectionItem.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import Foundation
import RxDataSources

enum ExploreSectionItem: IdentifiableType, Equatable {
    case category(job: JobCategory)
    case creator(nickName: String, userID: String)
    
    typealias Identity = String

    var identity: String {
        switch self {
        case .category(let job):
            return "category_\(job.rawValue)"
        case .creator(_, let userID):
            return "creator_\(userID)"
        }
    }
}
