//
//  PostCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/19.
//

import UIKit
import RxSwift
import RxCocoa

final class PostCell: UITableViewCell {
    // View Properties
    private let stackView = UIStackView().then { stackView in
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
    }

    private let creatorStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 10
    }

    private let creatorImageView = UIImageView().then { imageView in
        imageView.layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
    }

    private let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
    }

    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
    }

    private let postContentView = UIView()

    private let contentStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .bottom
    }

    private let contentLabel = UILabel().then { label in
        label.numberOfLines = Constants.unexpandedNumberOfLines
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
    }

    private let likeStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 10
    }

    private let likeButton = UIButton().then { button in
        button.setImage(Constants.unselectedLikeButtonImage, for: .normal)
    }

    private let likeCountLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
    }

    private let createdDateLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
    }

    private let disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        configureButtonActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.numberOfLines = Constants.unexpandedNumberOfLines
    }
}

// UI Method
extension PostCell {
    func configure(with post: Post) {
        creatorImageView.image = post.profileImage
        creatorNickNameLabel.text = post.nickName
        titleLabel.text = post.title
        contentLabel.text = post.content
        if post.isLiked {
            likeButton.setImage(Constants.selectedLikeButtonImage, for: .normal)
        } else {
            likeButton.setImage(Constants.unselectedLikeButtonImage, for: .normal)
        }
        likeCountLabel.text = "\(post.likeCount)개"
        createdDateLabel.text = post.formattedCreatedDate
    }
}

// Configure UI
private extension PostCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
    }

    func configureHierarchy() {
        [creatorImageView, creatorNickNameLabel].forEach(creatorStackView.addArrangedSubview)
        [likeButton, likeCountLabel, createdDateLabel].forEach(likeStackView.addArrangedSubview)
        [creatorStackView, titleLabel, postContentView, contentLabel, likeStackView]
            .forEach(stackView.addArrangedSubview)
        contentView.addSubview(stackView)
    }

    func configureConstraints() {
        [likeButton, likeCountLabel].forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        postContentView.snp.makeConstraints {
            $0.width.equalTo(postContentView.snp.height).priority(.required)
        }
        creatorImageView.snp.makeConstraints {
            $0.width.height.equalTo(50).priority(.required)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }

    func configureButtonActions() {
        configureShowMoreButtonAction()
    }

    func configureShowMoreButtonAction() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleExpended))
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(recognizer)

        likeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            print("*")
        }), for: .touchUpInside)
    }

    @objc
    func toggleExpended() {
        (superview as? UITableView)?.performBatchUpdates({
            contentLabel.numberOfLines = Constants.expandedNumberOfLines
        })
    }

    enum Constants {
        static let expandedNumberOfLines = 0
        static let unexpandedNumberOfLines = 2
        static let unselectedLikeButtonImage = UIImage(systemName: "hand.thumbsup")
        static let selectedLikeButtonImage = UIImage(systemName: "hand.thumbsup.fill")
    }
}
