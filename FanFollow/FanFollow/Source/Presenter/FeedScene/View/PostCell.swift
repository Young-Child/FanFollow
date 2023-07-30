//
//  PostCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/19.
//

import UIKit
import WebKit
import Kingfisher

final class PostCell: UITableViewCell {
    // View Properties
    private let outerView = UIView().then { view in
        view.backgroundColor = .systemBackground
    }

    private let stackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.spacing = 10
    }

    private let creatorStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 30
    }

    private let creatorImageView = UIImageView().then { imageView in
        imageView.layer.backgroundColor = Constants.creatorImageViewBackgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
    }

    private let creatorNickNameLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.textColor = Constants.creatorNickNameLabelTextColor
        label.font = .systemFont(ofSize: 17, weight: .regular)
    }

    let creatorUnderLineView = UIView().then { view in
        view.backgroundColor = UIColor.systemGray4
    }

    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }

    private let postContentView = UIView()

    private let videoWebView = {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        return WKWebView(frame: .zero, configuration: webViewConfiguration)
    }()

    private let imagesScrollView = UIScrollView().then { scrollView in
        scrollView.isPagingEnabled = true
    }

    private let imagesStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        (0...4).forEach { _ in
            let imageView = UIImageView().then { imageView in
                imageView.contentMode = .scaleAspectFit
                imageView.isHidden = true
            }
            stackView.addArrangedSubview(imageView)
        }
    }

    private let contentStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .bottom
    }

    private let contentLabel = UILabel().then { label in
        label.numberOfLines = Constants.unexpandedNumberOfLines
        label.font = .systemFont(ofSize: 16, weight: .regular)
    }

    let contentUnderLineView = UIView().then { view in
        view.backgroundColor = UIColor.systemGray4
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
        label.font = .systemFont(ofSize: 16, weight: .regular)
    }

    private let createdDateLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
    }

    private var postID: String?
    private var creatorID: String?
    private weak var delegate: PostCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.numberOfLines = Constants.unexpandedNumberOfLines
        imagesStackView.arrangedSubviews.forEach { view in view.isHidden = true }
        if videoWebView.isLoading { videoWebView.stopLoading() }
    }
}

// UI Method
extension PostCell {
    func configure(with post: Post, delegate: PostCellDelegate? = nil, creatorViewIsHidden: Bool = false) {
        let userID = post.userID
        creatorImageView.setImageProfileImage(to: post.writerProfileImageURL, for: userID)
        creatorNickNameLabel.text = post.nickName
        titleLabel.text = post.title
        contentLabel.text = post.content
        if post.isLiked {
            likeButton.setImage(Constants.selectedLikeButtonImage, for: .normal)
        } else {
            likeButton.setImage(Constants.unselectedLikeButtonImage, for: .normal)
        }
        likeCountLabel.text = "\(post.likeCount)개"
        createdDateLabel.text = post.createdDateDescription
        configurePostContentView(with: post)

        self.postID = post.postID
        self.creatorID = userID
        self.delegate = delegate

        switch creatorViewIsHidden {
        case false:
            [creatorStackView, creatorUnderLineView].forEach { $0.isHidden = false }
            contentView.backgroundColor = .systemGray6
        case true:
            [creatorStackView, creatorUnderLineView].forEach { $0.isHidden = true }
            contentView.backgroundColor = .systemBackground
        }
    }

    private func configurePostContentView(with post: Post) {
        if let videoURL = post.videoURL {
            (imagesScrollView.isHidden, videoWebView.isHidden) = (true, false)

            guard let videoURL = URL(string: videoURL) else { return }
            configurePostVideo(videoURL: videoURL)
        } else {
            (imagesScrollView.isHidden, videoWebView.isHidden) = (false, true)

            configurePostImages(to: post)
        }
    }

    private func configurePostVideo(videoURL: URL) {
        let videoRequest = URLRequest(url: videoURL)
        self.videoWebView.load(videoRequest)
    }

    private func configurePostImages(to post: Post) {
        imagesStackView.arrangedSubviews.enumerated().forEach { offset, view in
            guard let imageView = view as? UIImageView,
                  let postID = post.postID else { return }
            
            let url = post.generatePostImageURL(for: postID, to: offset)
            let path = postID + "_" + (offset + 1).description
            
            imageView.setImagePostImage(to: url, key: path) { result in
                switch result {
                case .success:
                    imageView.isHidden = false
                case .failure:
                    imageView.isHidden = true
                }
            }
        }
    }
}

// Configure UI
private extension PostCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureLikeButtonAction()
        addGestureRecognizerToContentLabel()
        addGestureRecognizerToCreatorNickNameLabel()
    }

    func configureHierarchy() {
        [creatorImageView, creatorNickNameLabel].forEach(creatorStackView.addArrangedSubview)
        imagesScrollView.addSubview(imagesStackView)
        [videoWebView, imagesScrollView].forEach(postContentView.addSubview)
        [likeButton, likeCountLabel, createdDateLabel].forEach(likeStackView.addArrangedSubview)
        [creatorStackView, creatorUnderLineView, titleLabel, postContentView, contentLabel, contentUnderLineView,
         likeStackView].forEach(stackView.addArrangedSubview)
        outerView.addSubview(stackView)
        contentView.addSubview(outerView)
    }

    func configureConstraints() {
        [titleLabel, contentLabel].forEach {
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        [likeButton, likeCountLabel].forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        postContentView.snp.makeConstraints {
            $0.width.equalTo(postContentView.snp.height).priority(.required)
        }
        creatorImageView.snp.makeConstraints {
            $0.width.height.equalTo(50).priority(.required)
        }
        [creatorUnderLineView, contentUnderLineView].forEach { lineView in
            lineView.snp.makeConstraints { $0.height.equalTo(1) }
        }
        videoWebView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imagesScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imagesStackView.snp.makeConstraints {
            $0.edges.equalTo(imagesScrollView.contentLayoutGuide)
        }
        imagesStackView.arrangedSubviews.forEach { imageView in
            imageView.snp.makeConstraints {
                $0.width.equalTo(imagesScrollView.snp.width)
                $0.height.equalTo(imagesScrollView.snp.height)
            }
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        outerView.snp.makeConstraints() {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }

    func configureLikeButtonAction() {
        likeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let postID = self?.postID else { return }
            self?.delegate?.likeButtonTap(postID: postID)
        }), for: .touchUpInside)
    }

    func addGestureRecognizerToContentLabel() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleExpended))
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(recognizer)
    }

    @objc
    func toggleExpended() {
        delegate?.performTableViewBathUpdates({ [weak self] in
            guard let self else { return }
            self.contentLabel.numberOfLines = Constants.expandedNumberOfLines
        })
    }

    func addGestureRecognizerToCreatorNickNameLabel() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(creatorNickNameLabelTap))
        creatorNickNameLabel.isUserInteractionEnabled = true
        creatorNickNameLabel.addGestureRecognizer(recognizer)
    }

    @objc
    func creatorNickNameLabelTap() {
        guard let creatorID else { return }
        delegate?.creatorNickNameLabelTap(creatorID: creatorID)
    }
}

// Constants
private extension PostCell {
    enum Constants {
        static let expandedNumberOfLines = 0
        static let unexpandedNumberOfLines = 2
        static let creatorImageViewBackgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        static let creatorNickNameLabelTextColor = UIColor(named: "AccentColor")
        static let unselectedLikeButtonImage = UIImage(systemName: "hand.thumbsup")
        static let selectedLikeButtonImage = UIImage(systemName: "hand.thumbsup.fill")
        static let failureProfileImage = UIImage(systemName: "person")!
        static let failurePostImage = UIImage(systemName: "photo")!
    }
}

// PostCellDelegate
protocol PostCellDelegate: AnyObject {
    func performTableViewBathUpdates(_ updates: (() -> Void)?)
    func likeButtonTap(postID: String)
    func creatorNickNameLabelTap(creatorID: String)
}
