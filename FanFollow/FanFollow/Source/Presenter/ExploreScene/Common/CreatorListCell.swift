//
//  CreatorListCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/24.
//

import UIKit
import SnapKit

final class CreatorListCell: UITableViewCell {
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
    
    private let jobLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "AccentColor")
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    private let introduceLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    private let labelTopStackView = UIStackView().then {
        $0.spacing = 20
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
    }
    
    private let labelStackView = UIStackView().then {
        $0.spacing = 15
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UI Method
extension CreatorListCell {
    func configureCell(nickName: String, userID: String, jobCategory: JobCategory, introduce: String) {
        guard let defaultImage = UIImage(systemName: "person") else { return }
        nickNameLabel.text = nickName
        profileImageView.setImageKF(
            to: "https://qacasllvaxvrtwbkiavx.supabase.co/storage/v1/object/ProfileImage/\(userID)/profileImage.png",
            failureImage: defaultImage
        )
        jobLabel.text = jobCategory.categoryName
        introduceLabel.text = introduce
    }
}

// Configure UI
private extension CreatorListCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [nickNameLabel, jobLabel].forEach { labelTopStackView.addArrangedSubview($0) }
        [labelTopStackView, introduceLabel].forEach { labelStackView.addArrangedSubview($0) }
        [profileImageView, labelTopStackView, labelStackView].forEach { contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(15)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
}
