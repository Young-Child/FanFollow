//
//  SettingSectionItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxDataSources

enum SettingSectionItem {
    case profile(imageName: String, nickName: String)
    case base(title: String)
}

extension SettingSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .profile(_, let nickName):
            return nickName
        case .base(let title):
            return title
        }
    }
}

extension SettingSectionItem: Equatable { }
