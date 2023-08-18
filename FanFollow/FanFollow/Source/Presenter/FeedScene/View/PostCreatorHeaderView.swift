//
//  PostCreatorHeaderView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class PostCreatorHeaderView: UIView {
    let creatorImageView = UIImageView().then { imageView in
        imageView.layer.backgroundColor = Constants.Color.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
    }
    
    let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.textColor = Constants.Color.blue
        label.font = .coreDreamFont(ofSize: 17, weight: .regular)
    }
    
    let optionsButton = UIButton().then { button in
        button.showsMenuAsPrimaryAction = true
        button.setImage(Constants.Image.more, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    func configureUI() {
        [creatorImageView, creatorNickNameLabel, optionsButton].forEach(addSubview)
        
        creatorImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(Constants.Spacing.small)
            $0.width.height.equalTo(50)
        }
        
        creatorNickNameLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(creatorImageView)
            $0.leading.equalTo(creatorImageView.snp.trailing).offset(Constants.Spacing.small)
        }
        
        optionsButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(userID: String, nickName: String?, imageURL: String) {
        self.creatorImageView.setImageProfileImage(to: imageURL, for: userID)
        self.creatorNickNameLabel.text = nickName
    }
    
    func configureActions(_ actions: [UIAction]) {
        let menu = UIMenu(
            options: .displayInline,
            children: actions
        )
        
        self.optionsButton.menu = menu
    }
}
