//
//  ProfileSectionModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/27.
//

import Differentiator

enum ProfileSectionModel {
    case profile(items: [ProfileSectionItem])
    case posts(items: [Post])
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = Any

    var items: [Item] {
        switch self {
        case .profile(let items):
            return items
        case .posts(let items):
            return items
        }
    }

    init(original: ProfileSectionModel, items: [Item]) {
        switch original {
        case .profile(let items):
            self = .profile(items: items)
        case .posts(let items):
            self = .posts(items: items)
        }
    }
}
