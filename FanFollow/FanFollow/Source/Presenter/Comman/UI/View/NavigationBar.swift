//
//  NavigationBar.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class FFNavigationBar: UIView {
    var leftBarButton = UIButton()
    var titleView = UILabel()
    var rightBarButton = UIButton()
    
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
            $0.leading.top.bottom.equalToSuperview().inset(8)
        }
        
        titleView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        rightBarButton.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview().inset(8)
        }
    }
}
