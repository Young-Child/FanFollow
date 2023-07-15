//
//  ProfileSettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import SnapKit

final class ProfileSettingViewController: UIViewController {
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "ExampleProfile")
    }
    
    private let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// Configure UI
private extension ProfileSettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [profileImageView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.width.equalTo(100).priority(.high)
            $0.height.equalTo(100).priority(.high)
        }
    }
}
