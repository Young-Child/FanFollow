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
    typealias Item = SettingSectionItem
    typealias Identity = String
    
    var items: [SettingSectionItem] {
        switch self {
        case .account(_, let items):
            return items.map { $0 }
        case .alert(_, let items):
            return items.map { $0 }
        case .customerService(_, let items):
            return items.map { $0 }
        case .profile(_, let items):
            return items.map { $0 }
        case .registerCreator(_, let items):
            return items.map { $0 }
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

extension SettingSectionModel {
    static let defaultModel: [SettingSectionModel] = [
        .profile(title: "", items: [
            .profile(imageName: "ExampleProfile", nickName: "미니"),
            .base(title: "크리에이터 신청"),
            .base(title: "알림 설정")
        ]),
        .customerService(title: "고객 센터", items: [
            .base(title: "버그 제보하기"),
            .base(title: "평가하기"),
            .base(title: "개인 정보 처리 방침"),
            .base(title: "오픈 소스 라이센스 고지")
        ]),
        .account(title: "계정 설정", items: [
            .base(title: "로그아웃"),
            .base(title: "탈퇴하기")
        ])
    ]
}
