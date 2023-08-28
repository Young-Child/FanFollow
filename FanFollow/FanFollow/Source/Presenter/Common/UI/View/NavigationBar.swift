//
//  NavigationBar.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class FFNavigationBar: UIView {
    var leftBarButton = UIButton().then {
        $0.titleLabel?.textColor = Constants.Color.blue
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    var titleView = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 16, weight: .medium)
    }
    
    var rightBarButton = UIButton().then {
        $0.titleLabel?.textColor = Constants.Color.blue
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
}

private extension FFNavigationBar {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [leftBarButton, titleView, rightBarButton].forEach(addSubview(_:))
    }
    
    func makeConstraints() {
        leftBarButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(Constants.Spacing.small)
        }
        
        titleView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        rightBarButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Spacing.small)
            $0.trailing.bottom.equalToSuperview().offset(-Constants.Spacing.small)
        }
    }
}
