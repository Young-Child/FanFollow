//
//  SettingTabBarController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol SettingTabBarDelegate: AnyObject {
    func settingController(_ controller: SettingViewController, removeFeedManageTab isCreator: Bool)
    func settingController(_ controller: SettingViewController, didTapPresent animated: Bool)
}

final class SettingTabBarController: TopTabBarController<SettingTabItem> {
    weak var coordinator: SettingCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
    }
    
    private func setDelegate() {
        guard let controller = viewControllers?.first as? SettingViewController else { return }
        controller.settingTabBarDelegate = self
    }
}

extension SettingTabBarController: SettingTabBarDelegate {
    func settingController(
        _ controller: SettingViewController,
        removeFeedManageTab isCreator: Bool
    ) {
        guard let itemCount = viewControllers?.count else { return }
        if itemCount <= 1 { return }
        
        let lastIndex = (itemCount - 1)
        viewControllers?.remove(at: lastIndex)
        hideTabBarItem(to: lastIndex)
        view.setNeedsLayout()
    }
    
    func settingController(_ controller: SettingViewController, didTapPresent animated: Bool) {
        coordinator?.presentSettingViewController()
    }
}
