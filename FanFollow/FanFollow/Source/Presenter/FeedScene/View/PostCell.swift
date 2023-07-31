//
//  PostCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/19.
//

import UIKit
import LinkPresentation

import Kingfisher

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
        
        contentLabel.numberOfLines = 5
    }
}

// UI Method
extension PostCell {
    func configure(with post: Post, delegate: PostCellDelegate? = nil, creatorViewIsHidden: Bool = false) {
        self.delegate = delegate
        
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
        configureLikeButtonAction(with: post.postID)
    }
    
    private func configureImageSlideView(with imageURLs: [String]) {
        if imageURLs.isEmpty {
            imageSlideView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            
            return
        }
        
        imageSlideView.pageControl = pageControl
        imageSlideView.setImageInputs(imageURLs)
        linkPreview.isHidden = true
        linkPreview.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
    
    private func configureLinkPreviews(with urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        let metaProvider = LPMetadataProvider()
        metaProvider.startFetchingMetadata(for: url) { meta, error in
            if let meta = meta {
                DispatchQueue.main.async {
                    self.linkPreview.setData(meta: meta)
                }
            }
        }
    }
    
    private func configureLikeButtonAction(with postID: String?) {
        let action = UIAction { [weak self] _ in
            guard let postID = postID, let self = self else { return }
            self.likeButton.isSelected.toggle()
            self.delegate?.postCell(self, didTappedLikeButton: postID)
        }
        likeButton.addAction(action, for: .touchUpInside)
    }
}

// Configure UI
private extension PostCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        
        addGestureRecognizerToContentLabel()
        addGestureRecognizerToCreatorNickNameLabel()
    }
    
    func configureHierarchy() {
        [titleLabel, contentLabel].forEach(contentStackView.addArrangedSubview(_:))
        
        [
            creatorHeaderView,
            imageSlideView,
            contentStackView,
            linkPreview,
            likeButton,
            createdDateLabel
        ].forEach(contentView.addSubview(_:))
    }
    
    func configureConstraints() {
        creatorHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        imageSlideView.snp.makeConstraints {
            $0.top.equalTo(creatorHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(imageSlideView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        linkPreview.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(linkPreview.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview().inset(8)
        }
        
        createdDateLabel.snp.makeConstraints {
            $0.top.equalTo(linkPreview.snp.bottom).offset(8)
            $0.trailing.bottom.equalToSuperview().inset(8)
        }
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
    
    func addGestureRecognizerToCreatorNickNameLabel() {
        //        let recognizer = UITapGestureRecognizer(target: self, action: #selector(creatorNickNameLabelTap))
        //        creatorNickNameLabel.isUserInteractionEnabled = true
        //        creatorNickNameLabel.addGestureRecognizer(recognizer)
    }
    
    @objc
    func creatorNickNameLabelTap() {
        //        guard let creatorID else { return }
        //        delegate?.creatorNickNameLabelTap(creatorID: creatorID)
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
    func postCell(expandLabel updateAction: (() -> Void)?)
    func postCell(_ cell: PostCell, didTappedLikeButton postID: String)
    func creatorNickNameLabelTap(creatorID: String)
}
