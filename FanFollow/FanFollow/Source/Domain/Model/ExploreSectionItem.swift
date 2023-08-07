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
    case creator(nickName: String, userID: String, profileURL: String)
    
    typealias Identity = String

    var identity: String {
        switch self {
        case .category(let job):
            return "category_\(job.rawValue)"
        case .creator(_, let userID, _):
            return "creator_\(userID)"
        }
    }
}

extension ExploreSectionItem {
    static func generateCreator(with creator: Creator) -> Self {
        return ExploreSectionItem.creator(nickName: creator.nickName, userID: creator.id, profileURL: creator.profileURL)
    }
}
