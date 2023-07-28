//
//  SettingSectionItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxDataSources

enum SettingSectionItem {
    case profile(nickName: String, userID: String, profileURL: String, action: SettingCoordinator.SettingPresentAction)
    case base(title: String, action: SettingCoordinator.SettingPresentAction)
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
    
    var presentType: SettingCoordinator.SettingPresentAction {
        switch self {
        case .profile(_, _, _, let action):
            return action
        case .base(_, let action):
            return action
        }
    }
}

extension SettingSectionItem: Equatable { }
