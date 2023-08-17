//
//  ProfileThumbnailCell.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher
import SnapKit

final class ProfileThumbnailCell: UITableViewCell {
    // View Properties
    private let profileImageView = UIImageView().then { imageView in
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.backgroundColor = Constants.Color.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
    }
    
    private let nickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .coreDreamFont(ofSize: 16, weight: .medium)
    }
    
    private let subTitleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .coreDreamFont(ofSize: 14, weight: .regular)
        label.textColor = Constants.Color.grayDark
        label.text = Constants.Text.profileEdit
    }
    
    // Initializer
    convenience init() {
        self.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = nil
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UI Method
extension ProfileThumbnailCell {
    func configureCell(nickName: String, userID: String, profileURL: String) {
        self.nickNameLabel.text = nickName
        self.profileImageView.setImageProfileImage(to: profileURL, for: userID)
    }
}

// Configure UI
private extension ProfileThumbnailCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [profileImageView, nickNameLabel, subTitleLabel].forEach { contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(Constants.Spacing.medium)
            $0.top.equalTo(contentView.snp.top).offset(Constants.Spacing.medium)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-Constants.Spacing.medium)
            $0.width.height.equalTo(50).priority(.high)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.centerY).offset(-Constants.Spacing.xSmall)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(Constants.Spacing.medium)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(Constants.Spacing.xSmall)
        }
    }
}
