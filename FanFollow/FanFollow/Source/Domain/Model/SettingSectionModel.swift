//
//  SettingSectionModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxDataSources

enum SettingSectionModel {
    case account(title: String, items: [SettingSectionItem])
    case alert(title: String, items: [SettingSectionItem])
    case customerService(title: String, items: [SettingSectionItem])
    case profile(title: String, items: [SettingSectionItem])
    case registerCreator(title: String, items: [SettingSectionItem])
}

extension SettingSectionModel: AnimatableSectionModelType {
    // TODO: - 아이템 타입 변경하기
    typealias Item = SettingSectionItem
    typealias Identity = String
    
    var items: [SettingSectionItem] {
        switch self {
        case .account(_, let items):
            return items
        case .alert(_, let items):
            return items
        case .customerService(_, let items):
            return items
        case .profile(_, let items):
            return items
        case .registerCreator(_, let items):
            return items
        }
    }
    
    var identity: String {
        switch self {
        case .account(let title, _):
            return title
        case .alert(let title, _):
            return title
        case .customerService(let title, _):
            return title
        case .profile(let title, _):
            return title
        case .registerCreator(let title, _):
            return title
        }
    }
    
    init(original: SettingSectionModel, items: [SettingSectionItem]) {
        switch original {
        case let .account(title, items):
            self = .account(title: title, items: items)
        case let .alert(title, items):
            self = .alert(title: title, items: items)
        case let .customerService(title, items):
            self = .customerService(title: title, items: items)
        case let .profile(title, items):
            self = .profile(title: title, items: items)
        case let .registerCreator(title, items):
            self = .registerCreator(title: title, items: items)
        }
    }
}
