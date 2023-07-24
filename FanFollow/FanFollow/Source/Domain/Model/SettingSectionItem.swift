//
//  SettingSectionItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxDataSources

enum SettingSectionItem {
    case profile(nickName: String, userID: String)
    case base(title: String)
}

extension SettingSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .profile(let nickName, let userID):
            return nickName + "_" + userID
        case .base(let title):
            return title
        }
    }
}

extension SettingSectionItem: Equatable { }
