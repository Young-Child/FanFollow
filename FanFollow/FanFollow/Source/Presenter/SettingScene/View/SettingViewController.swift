//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import Then

final class SettingViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        let settingButton = UIButton().then {
            $0.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
            $0.setTitle("설정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(.blue, for: .selected)
        }
        
        let feedManageButton = UIButton().then {
            $0.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
            $0.setTitle("피드 관리", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        let feedManageBarButton = UIBarButtonItem(customView: feedManageButton)
        
        navigationItem.leftBarButtonItems = [settingBarButton, feedManageBarButton]
    }
}
