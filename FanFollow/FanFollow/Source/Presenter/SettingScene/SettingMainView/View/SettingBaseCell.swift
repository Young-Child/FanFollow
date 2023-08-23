//
//  SettingBaseCell.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import SnapKit
import Then

final class SettingBaseCell: UITableViewCell {
    private let titleLabel = UILabel().then { label in
        label.textColor = Constants.Color.label
        label.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SettingBaseCell {
    func configureCell(to title: String) {
        titleLabel.text = title
    }
}

// Configure UI
private extension SettingBaseCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.Spacing.small)
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
        }
    }
}
