//
//  ProfileCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/28.
//

import UIKit

final class ProfileCell: UITableViewCell {
    // View Properties
    private let stackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
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
        stackView.spacing = 8
    }

    private let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }

    private let followerCountLabel = UILabel().then { label in
        label.numberOfLines = 1
    }

    private let followButton = UIButton().then { button in
        button.setTitle(Constants.followButtonText, for: .normal)
        button.setTitleColor(Constants.followButtonTitleColor, for: .normal)
        button.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private let introduceLabel = UILabel().then { label in
        label.numberOfLines = Constants.unexpandedNumberOfLines
        label.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    private let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
    }

    weak var delegate: ProfileCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UI Method
extension ProfileCell {
    func configure(with profile: Profile, viewType: ProfileFeedViewController.ViewType) {
        creatorImageView.setImageProfileImage(
            to: profile.creator.profileURL,
            for: profile.creator.id
        )
        
        creatorNickNameLabel.text = profile.creator.nickName
        configureFollowerCountLabel(count: profile.followersCount)
        followButton.isHidden = (viewType == .feedManage)
        introduceLabel.text = profile.creator.introduce
    }
    
    private func configureFollowerCountLabel(count: Int) {
        let attributedText = [
            NSAttributedString(
                string: "팔로워 ",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular)
                ]
            ),
            NSAttributedString(
                string: "\(count)명",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                    .foregroundColor: Constants.followerCountLabelTextColor ?? .clear
                ]
            )
        ].reduce(into: NSMutableAttributedString()) {
            $0.append($1)
        }
        followerCountLabel.attributedText = attributedText
    }
}

// Configure UI
private extension ProfileCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureFollowButtonAction()
        addGestureRecognizerToIntroduceLabel()
    }

    func configureHierarchy() {
        [creatorNickNameLabel, followerCountLabel].forEach(creatorStackView.addArrangedSubview)
        [creatorImageView, creatorStackView].forEach(stackView.addArrangedSubview)
        [stackView, followButton, introduceLabel].forEach(contentStackView.addArrangedSubview)
        contentView.addSubview(contentStackView)
    }

    func configureConstraints() {
        creatorImageView.snp.makeConstraints {
            $0.width.height.equalTo(80).priority(.required)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    func configureFollowButtonAction() {
        let action = UIAction { _ in self.delegate?.profileCell(didTapFollowButton: self) }
        followButton.addAction(action, for: .touchUpInside)
    }

    func addGestureRecognizerToIntroduceLabel() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleExpended))
        introduceLabel.isUserInteractionEnabled = true
        introduceLabel.addGestureRecognizer(recognizer)
    }

    @objc
    func toggleExpended() {
        let expandAction = { self.introduceLabel.numberOfLines = Constants.expandedNumberOfLines }
        delegate?.profileCell(cell: self, expandLabel: expandAction)
    }
}

// Constants
private extension ProfileCell {
    enum Constants {
        static let creatorImageViewBackgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        static let followerCountLabelTextColor = UIColor(named: "AccentColor")
        static let followButtonTitleColor = UIColor.white
        static let failureProfileImage = UIImage(systemName: "person")
        static let followButtonText = "팔로우 하기"
        static let unfollowButtonText = "팔로우 취소하기"
        static let expandedNumberOfLines = 5
        static let unexpandedNumberOfLines = 2
    }
}

// ProfileCellDelegate
protocol ProfileCellDelegate: AnyObject {
    func profileCell(cell: ProfileCell, expandLabel expandAction: (() -> Void)?)
    func profileCell(didTapFollowButton cell: ProfileCell)
}
