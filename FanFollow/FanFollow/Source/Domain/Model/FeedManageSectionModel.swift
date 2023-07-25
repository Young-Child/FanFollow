//
//  FeedManageSectionModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/25.
//

import Differentiator

enum FeedManageSectionModel {
    case creatorInformation(items: [CreatorInformationSectionItem])
    case posts(items: [Post])
}

extension FeedManageSectionModel: SectionModelType {
    typealias Item = Any

    var items: [Item] {
        switch self {
        case .creatorInformation(let items):
            return items
        case .posts(let items):
            return items
        }
    }

    init(original: FeedManageSectionModel, items: [Any]) {
        switch original {
        case .creatorInformation(let items):
            self = .creatorInformation(items: items)
        case .posts(let items):
            self = .posts(items: items)
        }
    }
}
