//
//  SettingTabBar.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

final class SettingTabBar: TabBar {
    private enum SettingTabItem: Int, TabItem {
        case setting
        case feedManage
        
        var description: String {
            switch self {
            case .setting:      return "설정"
            case .feedManage:   return "피드 관리"
            }
        }
    }
    
    convenience init() {
        self.init(tabItems: SettingTabItem.allCases)
    }
}
