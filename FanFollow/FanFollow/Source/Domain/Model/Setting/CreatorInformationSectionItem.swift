//
//  CreatorInformationSectionItem.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/25.
//

import Differentiator

struct CreatorInformationSectionItem {
    var creator: Creator
    var followerCount: Int
}

extension CreatorInformationSectionItem: IdentifiableType {
    typealias Identity = String

    var identity: String {
        return creator.id
    }
}

extension CreatorInformationSectionItem: Equatable {
    static func == (lhs: CreatorInformationSectionItem, rhs: CreatorInformationSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
