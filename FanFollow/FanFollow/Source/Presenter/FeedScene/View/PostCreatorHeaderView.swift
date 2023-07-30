//
//  PostCreatorHeaderView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class PostCreatorHeaderView: UIView {
    private let creatorImageView = UIImageView().then { imageView in
        imageView.layer.backgroundColor = UIColor.systemGray5.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
    }
    
    private let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.textColor = UIColor(named: "AccentColor")
        label.font = .systemFont(ofSize: 17, weight: .regular)
    }
    
    private let optionsButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
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
            $0.top.leading.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(50)
        }
        
        creatorNickNameLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(creatorImageView)
            $0.leading.equalTo(creatorImageView.snp.trailing).offset(8)
        }
        
        optionsButton.snp.makeConstraints {
            $0.top.bottom.equalTo(creatorImageView)
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(with creator: Creator) {
        self.creatorNickNameLabel.text = creator.nickName
    }
}
