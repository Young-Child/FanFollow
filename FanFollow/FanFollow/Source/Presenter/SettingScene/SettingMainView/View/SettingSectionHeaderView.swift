//
//  SettingSectionHeaderView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class SettingSectionHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel().then { label in
        label.textColor = Constants.Color.blue
        label.font = .coreDreamFont(ofSize: 18, weight: .medium)
    }
    
    convenience init() {
        self.init(reuseIdentifier: Self.reuseIdentifier)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureTitle(to title: String) {
        self.titleLabel.text = title
    }
}

private extension SettingSectionHeaderView {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(Constants.Spacing.small)
        }
    }
}
