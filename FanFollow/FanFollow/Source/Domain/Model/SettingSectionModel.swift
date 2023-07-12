//
//  SettingSectionModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxDataSources

enum SettingSectionModel {
    case account(title: String)
    case alert(title: String)
    case customerService(title: String)
    case profile(title: String)
    case registerCreator(title: String)
}

extension SettingSectionModel: AnimatableSectionModelType {
    // TODO: - 아이템 타입 변경하기
    typealias Item = String
    typealias Identity = String
    
    var items: [String] {
        return []
    }
    
    var identity: String {
        switch self {
        case .account(let title):
            return title
        case .alert(let title):
            return title
        case .customerService(let title):
            return title
        case .profile(let title):
            return title
        case .registerCreator(let title):
            return title
        }
    }
    
    init(original: SettingSectionModel, items: [String]) {
        switch original {
        case let .account(title):
            self = .account(title: title)
        case let .alert(title):
            self = .alert(title: title)
        case let .customerService(title):
            self = .customerService(title: title)
        case let .profile(title):
            self = .profile(title: title)
        case let .registerCreator(title):
            self = .registerCreator(title: title)
        }
    }
}
