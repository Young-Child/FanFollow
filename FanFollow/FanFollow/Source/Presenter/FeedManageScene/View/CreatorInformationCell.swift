//
//  CreatorInformationCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/25.
//

import UIKit

final class CreatorInformationCell: UITableViewCell {
    // View Properties
    private let stackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
    }

    private let creatorImageView = UIImageView().then { imageView in
        imageView.layer.backgroundColor = Constants.creatorImageViewBackgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
    }

    private let creatorStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
    }

    private let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }

    private let followerCountLabel = UILabel().then { label in
        label.numberOfLines = 1
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UI Method
extension CreatorInformationCell {
    func configure(with creator: Creator, followerCount: Int) {
        let creatorID = creator.id
        creatorImageView.setImageKF(
            to: "https://qacasllvaxvrtwbkiavx.supabase.co/storage/v1/object/ProfileImage/\(creatorID)/profileImage.png",
            failureImage: Constants.failureProfileImage,
            round: .round(cornerRadius: 40)
        )
        creatorNickNameLabel.text = creator.nickName
        configureFollowerCountLabel(count: followerCount)
    }

    private func configureFollowerCountLabel(count: Int) {
        let attributedText = [
            NSAttributedString(
                string: "팔로워 ",
                attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
            ),
            NSAttributedString(
                string: "\(count)명",
                attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                             .foregroundColor: Constants.followerCountLabelTextColor]
            )
        ].reduce(into: NSMutableAttributedString()) {
            $0.append($1)
        }
        followerCountLabel.attributedText = attributedText
    }
}

// Configure UI
private extension CreatorInformationCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
    }

    func configureHierarchy() {
        [creatorNickNameLabel, followerCountLabel].forEach(creatorStackView.addArrangedSubview)
        [creatorImageView, creatorStackView].forEach(stackView.addArrangedSubview)
        contentView.addSubview(stackView)
    }
    
    func configureConstraints() {
        creatorImageView.snp.makeConstraints {
            $0.width.height.equalTo(80).priority(.required)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
}

private extension CreatorInformationCell {
    enum Constants {
        static let creatorImageViewBackgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        static let followerCountLabelTextColor = UIColor(named: "AccentColor")!
        static let failureProfileImage = UIImage(systemName: "person")!
    }
}
