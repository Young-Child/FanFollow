//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import Then

final class SettingViewController: UIViewController {
    private let tabBar = SettingTabBar()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabBar)
    }
}
