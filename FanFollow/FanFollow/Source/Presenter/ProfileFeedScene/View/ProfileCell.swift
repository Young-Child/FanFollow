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
        imageView.layer.cornerRadius = 25
    }

    private let creatorStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
    }

    private let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private let followerCountLabel = UILabel().then { label in
        label.numberOfLines = 1
    }

    private let followButton: UIButton = {
        let button: UIButton
        if #available(iOS 15.0, *) {
            var content = UIButton.Configuration.plain()
            content.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            button = UIButton(configuration: content)
        } else {
            button = UIButton()
            button.contentEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: -2, right: 0)
        }
        button.setAttributedTitle(Constants.followButtonText, for: .normal)
        button.setTitleColor(Constants.followButtonTitleColor, for: .normal)
        return button
    }()

    private let introduceLabel = UILabel().then { label in
        label.numberOfLines = Constants.unexpandedNumberOfLines
        label.font = .systemFont(ofSize: 14, weight: .light)
    }

    private weak var delegate: ProfileCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        introduceLabel.numberOfLines = Constants.unexpandedNumberOfLines
    }
}

// UI Method
extension ProfileCell {
    func configure(with creator: Creator, followerCount: Int, isFollow: Bool, delegate: ProfileCellDelegate? = nil, followButtonIsHidden: Bool) {
        let creatorID = creator.id
        creatorImageView.setImageProfileImage(to: "https://qacasllvaxvrtwbkiavx.supabase.co/storage/v1/object/ProfileImage/\(creatorID)/profileImage.png")

        creatorNickNameLabel.text = creator.nickName
        configureFollowerCountLabel(count: followerCount)

        let followButtonTitle = isFollow ? Constants.unfollowButtonText : Constants.followButtonText
        followButton.setAttributedTitle(followButtonTitle, for: .normal)
        followButton.isHidden = followButtonIsHidden

        introduceLabel.text = creator.introduce

        self.delegate = delegate
    }

    private func configureFollowerCountLabel(count: Int) {
        let attributedText = [
            NSAttributedString(
                string: "팔로워 ",
                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
            ),
            NSAttributedString(
                string: "\(count)명",
                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                             .foregroundColor: Constants.followerCountLabelTextColor]
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
        [creatorNickNameLabel, followerCountLabel, followButton].forEach(creatorStackView.addArrangedSubview)
        [creatorImageView, creatorStackView].forEach(stackView.addArrangedSubview)
        [stackView, introduceLabel].forEach(contentView.addSubview)
    }

    func configureConstraints() {
        [creatorNickNameLabel, followerCountLabel, followButton].forEach {
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        creatorImageView.snp.makeConstraints {
            $0.width.height.equalTo(50).priority(.required)
        }
        stackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(16)
        }
        introduceLabel.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.leading)
            $0.trailing.equalTo(stackView.snp.trailing)
            $0.top.equalTo(stackView.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    func configureFollowButtonAction() {
        followButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.followButtonTap()
        }), for: .touchUpInside)
    }

    func addGestureRecognizerToIntroduceLabel() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleExpended))
        introduceLabel.isUserInteractionEnabled = true
        introduceLabel.addGestureRecognizer(recognizer)
    }

    @objc
    func toggleExpended() {
        delegate?.performTableViewBathUpdates({ [weak self] in
            guard let self else { return }
            self.introduceLabel.numberOfLines = Constants.expandedNumberOfLines
        })
    }
}

// Constants
private extension ProfileCell {
    enum Constants {
        static let creatorImageViewBackgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        static let followerCountLabelTextColor = UIColor(named: "AccentColor")!
        static let followButtonTitleColor = UIColor.black
        static let failureProfileImage = UIImage(systemName: "person")!
        static let followButtonText = NSAttributedString(
            string: "팔로우 하기",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
        static let unfollowButtonText = NSAttributedString(
            string: "팔로우 취소하기",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
        static let expandedNumberOfLines = 5
        static let unexpandedNumberOfLines = 2
    }
}

// ProfileCellDelegate
protocol ProfileCellDelegate: AnyObject {
    func performTableViewBathUpdates(_ updates: (() -> Void)?)
    func followButtonTap()
}
