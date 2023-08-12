//
//  CreatorCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit

import SnapKit

final class CreatorCell: UICollectionViewCell {
    // View Properties
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(named: "SecondaryColor")
    }
    
    private let nickNameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "AccentColor")
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
    }
}

// UI Method
extension CreatorCell {
    func configureCell(nickName: String, userID: String, profileURL: String) {
        nickNameLabel.text = nickName
        profileImageView.setImageProfileImage(to: profileURL, for: userID)
    }
}

// Configure UI
private extension CreatorCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [profileImageView, nickNameLabel].forEach { contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(contentView.snp.width).multipliedBy(0.8)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(profileImageView)
        }
    }
}
