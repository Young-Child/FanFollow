//
//  SettingSectionItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxDataSources

enum SettingSectionItem {
    enum PresentType {
        case profile
        case creator
        case blockCreatorManagement
        case alert
        case bugReport
        case evaluation
        case privacy
        case openSource
        case logOut
        case withdrawal
    }
    
    case profile(nickName: String, userID: String, profileURL: String, action: PresentType)
    case base(title: String, action: PresentType)
}

extension SettingSectionItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .profile(let nickName, let userID, _, _):
            return nickName + "_" + userID + "_" + UUID().uuidString
        case .base(let title, _):
            return title
        }
    }
    
    var presentType: PresentType {
        switch self {
        case .profile(_, _, _, let action):
            return action
        case .base(_, let action):
            return action
        }
    }
}

extension SettingSectionItem: Equatable { }
