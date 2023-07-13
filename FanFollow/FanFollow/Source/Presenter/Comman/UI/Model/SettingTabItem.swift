//
//  SettingTabItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

enum SettingTabItem: Int, TabItem {
    case setting
    case feedManage
    
    var description: String {
        switch self {
        case .setting:      return "설정"
        case .feedManage:   return "피드 관리"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .setting: return SettingViewController()
        case .feedManage: return UIViewController()
        }
    }
}