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
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "AccentColor")
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let jobLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "AccentColor")
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let introduceLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let labelStackView = UIStackView().then {
        $0.spacing = 5
        $0.alignment = .leading
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
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
        jobLabel.text = Constants.category + " " + jobCategory.categoryName
        introduceLabel.text = introduce
        
        applyAttributedString()
    }
    
    private func applyAttributedString() {
        let attributedString = NSMutableAttributedString(string: jobLabel.text ?? "")
        guard let text = jobLabel.text else { return }
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.lightGray,
            range: (text as NSString).range(of: Constants.category)
        )
        jobLabel.attributedText = attributedString
    }
}

// Configure UI
private extension CreatorListCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [nickNameLabel, jobLabel, introduceLabel].forEach { labelStackView.addArrangedSubview($0) }
        [profileImageView, labelStackView].forEach { contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(15)
            $0.height.width.equalTo(60)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
                
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
}

private extension CreatorListCell {
    enum Constants {
        static let category = "직군"
    }
}