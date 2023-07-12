//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import Then

final class SettingViewController: TopTabBarController {
    convenience init() {
        self.init(tabBar: SettingTabBar())
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
    }
}
