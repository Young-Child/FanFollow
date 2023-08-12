//
//  SettingSectionHeaderView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class SettingSectionHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel().then { label in
        label.textColor = Constants.Color.blue
        label.font = .systemFont(ofSize: 18, weight: .semibold)
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
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}
