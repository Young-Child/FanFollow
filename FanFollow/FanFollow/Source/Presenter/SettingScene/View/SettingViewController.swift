//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import Then

final class SettingViewController: TopTabBarController {
    // View Properties
    
    // Properties
    
    // Initializer
    convenience init() {
        self.init(tabBar: SettingTabBar())
    }
    
    // Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
    }
}

// UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
}

// Configure UI
private extension SettingViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        
    }
    
    func makeConstraints() {
        
    }
}
