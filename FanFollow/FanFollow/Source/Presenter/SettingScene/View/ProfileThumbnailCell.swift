//
//  ProfileThumbnailCell.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import SnapKit

final class ProfileThumbnailCell: UITableViewCell {
    // View Properties
    private let profileImageView = UIImageView().then { imageView in
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private let nickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    private let subTitleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(named: "SecondaryColor")
        label.text = "프로필 수정하기"
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
    func configureCell(nickName: String, image: UIImage?) {
        self.profileImageView.image = image
        self.nickNameLabel.text = nickName
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
            $0.leading.equalTo(contentView).offset(16)
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-16)
            $0.width.lessThanOrEqualTo(50)
            $0.height.lessThanOrEqualTo(profileImageView.snp.width).priority(.high)
        }
        
        profileImageView.layer.cornerRadius = 25
        
        nickNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.centerY).offset(-5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(5)
        }
    }
}
