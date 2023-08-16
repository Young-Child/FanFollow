//
//  ProfileCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/28.
//

import UIKit

// ProfileCellDelegate
protocol ProfileCellDelegate: AnyObject {
    func profileCell(cell: ProfileCell, expandLabel expandAction: (() -> Void)?)
    func profileCell(didTapFollowButton cell: ProfileCell)
}

final class ProfileCell: UITableViewCell {
    // View Properties
    private let stackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
    }

    private let creatorImageView = UIImageView().then { imageView in
        imageView.layer.backgroundColor = Constants.Color.gray.cgColor
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
        label.font = .coreDreamFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
    }

    private let followerCountLabel = UILabel().then { label in
        label.font = .coreDreamFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
    }

    private let followButton = UIButton().then { button in
        button.setTitle(Constants.Text.unfollowButtonTitle, for: .selected)
        button.setTitleColor(Constants.Color.grayDark, for: .selected)
        button.setTitle(Constants.Text.followButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = Constants.Color.blue.cgColor
        button.layer.cornerRadius = 4
        button.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .medium)
    }

    private let introduceLabel = UILabel().then { label in
        label.numberOfLines = 2
        label.font = .coreDreamFont(ofSize: 16, weight: .regular)
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
    func configure(with profile: ProfileFeedSectionItem, viewType: ProfileFeedViewController.ViewType) {
        creatorImageView.setImageProfileImage(
            to: profile.creator.profileURL,
            for: profile.creator.id
        )
        creatorNickNameLabel.text = profile.creator.nickName
        followButton.isHidden = (viewType == .feedManage)
        introduceLabel.text = profile.creator.introduce
        
        configureFollowerCountLabel(count: profile.followerCount)
        configureFollowButton(isFollow: profile.isFollow)
        configureFollowButtonAction()
    }
    
    private func configureFollowerCountLabel(count: Int) {
        let attributedText = [
            NSAttributedString(
                string: Constants.Text.follower,
                attributes: [
                    .font: UIFont.coreDreamFont(ofSize: 16, weight: .regular) as Any
                ]
            ),
            NSAttributedString(
                string: "\(count)" + Constants.Text.personUnit,
                attributes: [
                    .font: UIFont.coreDreamFont(ofSize: 16, weight: .regular) as Any,
                    .foregroundColor: Constants.Color.blue
                ]
            )
        ].reduce(into: NSMutableAttributedString()) {
            $0.append($1)
        }
        followerCountLabel.attributedText = attributedText
    }
    
    private func configureFollowButton(isFollow: Bool) {
        followButton.isSelected = isFollow
        let backgroundColor = isFollow ? Constants.Color.gray : Constants.Color.blue
        followButton.layer.backgroundColor = backgroundColor.cgColor
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
            $0.edges.equalToSuperview().inset(8)
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
        let expandAction = { self.introduceLabel.numberOfLines = 5 }
        delegate?.profileCell(cell: self, expandLabel: expandAction)
    }
}
