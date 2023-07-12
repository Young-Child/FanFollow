//
//  TopTapBarController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class TopTabBarController: UIViewController {
    private let tabBar: TabBar
    
    init(tabBar: TabBar) {
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
        
        configureNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        tabBar = TabBar(tabItems: [])
        super.init(coder: coder)
    }
    
    private func configureNavigationBar() {
        let tabBarItem = UIBarButtonItem(customView: tabBar)
        navigationItem.leftBarButtonItem = tabBarItem
    }
}
