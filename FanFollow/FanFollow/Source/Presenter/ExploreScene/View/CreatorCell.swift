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
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(named: "SecondaryColor")
    }
    
    private let nickNameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "AccentColor")
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UI Method
extension CreatorCell {
    func configureCell(nickName: String, userID: String) {
        guard let defaultImage = UIImage(systemName: "person") else { return }
        nickNameLabel.text = nickName
        profileImageView.setImageKF(
            to: "https://qacasllvaxvrtwbkiavx.supabase.co/storage/v1/object/ProfileImage/\(userID)/profileImage.png",
            failureImage: defaultImage
        )
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
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
    }
}
