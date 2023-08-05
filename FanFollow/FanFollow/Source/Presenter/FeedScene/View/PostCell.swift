//
//  PostCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/19.
//

import UIKit
import LinkPresentation

import Kingfisher

protocol PostCellDelegate: AnyObject {
    func postCell(expandLabel updateAction: (() -> Void)?)
    func postCell(_ cell: PostCell, didTappedLikeButton postID: String)
    func postCell(didTapProfilePresentButton creatorID: String)
    func postCell(didTapLinkPresentButton link: URL)
}

final class PostCell: UITableViewCell {
    // View Properties
    private let creatorHeaderView = PostCreatorHeaderView()
    
    private let imageSlideView = HorizontalImageSlideView()
    
    private let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = UIColor.systemGray5
        $0.backgroundStyle = .minimal
        $0.currentPageIndicatorTintColor = UIColor(named: "AccentColor")
    }
    
    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then { label in
        label.numberOfLines = 5
    }
    
    private let linkPreview = LinkPreview()
    
    private let contentStackView = UIStackView().then { stackView in
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.distribution = .fill
    }
    
    private let likeButton = UIButton().then { button in
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        let unSelectedImage = UIImage(
            systemName: "heart",
            withConfiguration: imageConfiguration
        )
        let selectedImage = UIImage(
            systemName: "heart.fill",
            withConfiguration: imageConfiguration
        )
        
        button.setImage(unSelectedImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
    }
    
    private let createdDateLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
    }
    
    private let likeButtonStackView = UIView()
    
    private let postCellContentView = UIStackView().then { stackView in
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
    }
    
    // Properties
    private weak var delegate: PostCellDelegate?
    private var post: Post?
    
    // Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        post = nil
        titleLabel.text = nil
        contentLabel.text = nil
        contentLabel.numberOfLines = 5
        likeButton.isSelected = false
        imageSlideView.resetImages()
        imageSlideView.isHidden = false
        linkPreview.isHidden = false
        linkPreview.resetData()
        
        imageSlideView.snp.updateConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        
        linkPreview.snp.updateConstraints {
            $0.height.equalTo(80)
        }
    }
}

// Setting UI Data
extension PostCell {
    func configure(with post: Post, delegate: PostCellDelegate? = nil, isHiddenHeader: Bool = false) {
        self.post = post
        self.delegate = delegate
        
        creatorHeaderView.isHidden = isHiddenHeader
        creatorHeaderView.configure(
            userID: post.userID,
            nickName: post.nickName,
            imageURL: post.writerProfileImageURL
        )
        likeButton.isSelected = post.isLiked
        titleLabel.text = post.title
        contentLabel.text = post.content
        createdDateLabel.text = post.createdDateDescription
        
        configureImageSlideView(with: post.imageURLs)
        configureLinkPreviews(with: post.videoURL)
        
        addGestures()
    }
    
    private func configureImageSlideView(with imageURLs: [String]) {
        let isHidden = imageURLs.isEmpty
        
        imageSlideView.isHidden = isHidden
        linkPreview.isHidden = (isHidden == false)
        
        imageSlideView.pageControl = pageControl
        imageSlideView.setImageInputs(imageURLs)
    }
    
    private func configureLinkPreviews(with urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        let metaProvider = LPMetadataProvider()
        
        if let metaData = LinkCacheService.retrieve(url: urlString) {
            self.linkPreview.setData(meta: metaData)
            return
        }
        
        metaProvider.startFetchingMetadata(for: url) { meta, error in
            if let meta = meta {
                DispatchQueue.main.async {
                    self.linkPreview.setData(meta: meta)
                    LinkCacheService.cache(metaData: meta)
                    metaProvider.cancel()
                }
            }
        }
    }
    
}

// Configure UI Actions
private extension PostCell {
    func addGestures() {
        configureLikeButtonAction()
        addGestureRecognizerToContentLabel()
        addGestureRecognizerToPresentProfileViews()
        addGestureRecognizerToPresentLink()
    }
    
    func configureLikeButtonAction() {
        let action = UIAction { [weak self] _ in
            guard let postID = self?.post?.postID, let self = self else { return }
            self.delegate?.postCell(self, didTappedLikeButton: postID)
        }
        likeButton.addAction(action, for: .touchUpInside)
    }
    
    func addGestureRecognizerToContentLabel() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleExpended))
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(recognizer)
    }
    
    @objc
    func toggleExpended() {
        let expandLabelAction = { self.contentLabel.numberOfLines = .zero }
        delegate?.postCell(expandLabel: expandLabelAction)
    }
    
    func addGestureRecognizerToPresentProfileViews() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPresentProfile))
        
        let imageView = creatorHeaderView.creatorImageView
        let nameLabel = creatorHeaderView.creatorNickNameLabel
        
        [imageView, nameLabel].forEach {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func didTapPresentProfile() {
        guard let creatorID = self.post?.userID else { return }
        delegate?.postCell(didTapProfilePresentButton: creatorID)
    }
    
    func addGestureRecognizerToPresentLink() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPresentLink))
        
        linkPreview.isUserInteractionEnabled = true
        linkPreview.addGestureRecognizer(recognizer)
    }
    
    @objc func didTapPresentLink() {
        guard let urlString = post?.videoURL,
              let url = URL(string: urlString) else { return }
        delegate?.postCell(didTapLinkPresentButton: url)
    }
}

// Configure UI
private extension PostCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, contentLabel].forEach(contentStackView.addArrangedSubview(_:))
        [likeButton, createdDateLabel].forEach(likeButtonStackView.addSubview(_:))
        
        [
            creatorHeaderView,
            imageSlideView,
            contentStackView,
            linkPreview,
            likeButtonStackView
        ].forEach(postCellContentView.addArrangedSubview(_:))
        
        contentView.addSubview(postCellContentView)
    }
    
    func configureConstraints() {
        likeButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(8)
        }
        
        createdDateLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(8)
        }
        
        
        postCellContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageSlideView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        
        linkPreview.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width).multipliedBy(0.3)
        }
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
