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
    private let creatorHeaderView = PostCreatorHeaderView()
    
    private let titleLabel = UILabel().then { label in
        label.text = "Example Title"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then { label in
        label.text = """
풀이 구하지 실로 칼이다. 인도하겠다는 인생을 못하다 있는 뜨거운지라, 꽃이 찾아 보이는 이것이다. 있는 긴지라 청춘의 소리다.이것은 사막이다. 청춘은 예가 아니더면, 하는 가치를 사막이다. 오직 생생하며, 원대하고, 남는 든 밝은 그들은 영락과 피어나기 것이다. 아니더면, 창공에 열락의 위하여서. 천하를 뛰노는 방황하였으며, 뿐이다. 소리다.이것은 기쁘며, 물방아 살았으며, 않는 고동을 새가 관현악이며, 약동하다. 못할 동력은 방지하는 대한 쓸쓸하랴? 바이며, 가치를 힘차게 그림자는 이는 용기가 때문이다. 피어나기 힘차게 풍부하게 피에 되는 오직 청춘 것이다.

바이며, 보배를 그들을 것이다. 그들은 오아이스도 품었기 동산에는 가는 인간에 품으며, 있다. 얼마나 그들에게 설레는 말이다. 물방아 위하여 무엇을 대한 얼음이 말이다. 하여도 심장의 봄바람을 인간에 얼마나 것이다. 구할 심장은 것은 희망의 피어나는 주는 봄바람이다. 가는 그들의 인류의 살 것이다. 그들은 바이며, 인간이 영락과 인생을 사막이다. 살았으며, 인간이 장식하는 이것은 같은 보내는 영원히 것이다.

인생의 청춘에서만 맺어, 현저하게 아름다우냐? 거친 우리의 옷을 과실이 방황하였으며, 심장의 인간의 든 아니다. 얼음에 없으면, 광야에서 같은 부패뿐이다. 사는가 기관과 남는 귀는 무엇을 피어나기 것이다. 보배를 힘차게 위하여서, 온갖 위하여, 곳으로 못할 사람은 쓸쓸하랴? 이상이 천하를 힘차게 주는 품에 있을 날카로우나 사막이다. 끝에 가슴에 타오르고 부패뿐이다. 관현악이며, 황금시대를 보이는 따뜻한 것이다.보라, 앞이 교향악이다. 아니한 무엇을 싶이 안고, 것은 인생에 놀이 들어 힘있다. 투명하되 사랑의 밥을 듣기만 만물은 이것이다. 품으며, 할지라도 대중을 남는 창공에 교향악이다.
"""
        label.numberOfLines = 5
    }
    
    private let contentStackView = UIStackView().then { stackView in
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.distribution = .fill
    }
    
//    private let outerView = UIView().then { view in
//        view.backgroundColor = .systemBackground
//    }
//
//    private let stackView = UIStackView().then { stackView in
//        stackView.axis = .vertical
//        stackView.spacing = 10
//    }
//
//    private let creatorStackView = UIStackView().then { stackView in
//        stackView.axis = .horizontal
//        stackView.spacing = 30
//    }
//
//    private let creatorImageView = UIImageView().then { imageView in
//        imageView.layer.backgroundColor = Constants.creatorImageViewBackgroundColor
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 25
//    }
//
//    private let creatorNickNameLabel = UILabel().then { label in
//        label.numberOfLines = 1
//        label.textColor = Constants.creatorNickNameLabelTextColor
//        label.font = .systemFont(ofSize: 17, weight: .regular)
//    }
//
//    let creatorUnderLineView = UIView().then { view in
//        view.backgroundColor = UIColor.systemGray4
//    }
//
//    private let titleLabel = UILabel().then { label in
//        label.numberOfLines = 1
//        label.font = .systemFont(ofSize: 20, weight: .bold)
//    }
//
//    private let postContentView = UIView()
//
//    private let videoWebView = {
//        let webViewConfiguration = WKWebViewConfiguration()
//        webViewConfiguration.allowsInlineMediaPlayback = true
//        return WKWebView(frame: .zero, configuration: webViewConfiguration)
//    }()
//
//    private let imagesScrollView = UIScrollView().then { scrollView in
//        scrollView.isPagingEnabled = true
//    }
//
//    private let imagesStackView = UIStackView().then { stackView in
//        stackView.axis = .horizontal
//        (0...4).forEach { _ in
//            let imageView = UIImageView().then { imageView in
//                imageView.contentMode = .scaleAspectFit
//                imageView.isHidden = true
//            }
//            stackView.addArrangedSubview(imageView)
//        }
//    }
//
//    private let contentStackView = UIStackView().then { stackView in
//        stackView.axis = .horizontal
//        stackView.alignment = .bottom
//    }
//
//    private let contentLabel = UILabel().then { label in
//        label.numberOfLines = Constants.unexpandedNumberOfLines
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//    }
//
//    let contentUnderLineView = UIView().then { view in
//        view.backgroundColor = UIColor.systemGray4
//    }
//
//    private let likeStackView = UIStackView().then { stackView in
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//    }
//
//    private let likeButton = UIButton().then { button in
//        button.setImage(Constants.unselectedLikeButtonImage, for: .normal)
//    }
//
//    private let likeCountLabel = UILabel().then { label in
//        label.numberOfLines = 1
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//    }
//
//    private let createdDateLabel = UILabel().then { label in
//        label.numberOfLines = 1
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//        label.textAlignment = .right
//    }

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
//        contentLabel.numberOfLines = Constants.unexpandedNumberOfLines
//        imagesStackView.arrangedSubviews.forEach { view in view.isHidden = true }
//        if videoWebView.isLoading { videoWebView.stopLoading() }
    }
}

// UI Method
extension PostCell {
    func configure(with post: Post, delegate: PostCellDelegate? = nil, creatorViewIsHidden: Bool = false) {
        self.delegate = delegate
//        let userID = post.userID
//        creatorImageView.setImageProfileImage(to: post.writerProfileImageURL, for: userID)
//        creatorNickNameLabel.text = post.nickName
//        titleLabel.text = post.title
//        contentLabel.text = post.content
//        if post.isLiked {
//            likeButton.setImage(Constants.selectedLikeButtonImage, for: .normal)
//        } else {
//            likeButton.setImage(Constants.unselectedLikeButtonImage, for: .normal)
//        }
//        likeCountLabel.text = "\(post.likeCount)개"
//        createdDateLabel.text = post.createdDateDescription
//        configurePostContentView(with: post)
//
//        self.postID = post.postID
//        self.creatorID = userID
//        self.delegate = delegate
//
//        switch creatorViewIsHidden {
//        case false:
//            [creatorStackView, creatorUnderLineView].forEach { $0.isHidden = false }
//            contentView.backgroundColor = .systemGray6
//        case true:
//            [creatorStackView, creatorUnderLineView].forEach { $0.isHidden = true }
//            contentView.backgroundColor = .systemBackground
//        }
    }

    private func configurePostContentView(with post: Post) {
//        if let videoURL = post.videoURL {
//            (imagesScrollView.isHidden, videoWebView.isHidden) = (true, false)
//
//            guard let videoURL = URL(string: videoURL) else { return }
//            configurePostVideo(videoURL: videoURL)
//        } else {
//            (imagesScrollView.isHidden, videoWebView.isHidden) = (false, true)
//
//            configurePostImages(to: post)
//        }
    }

    private func configurePostVideo(videoURL: URL) {
//        let videoRequest = URLRequest(url: videoURL)
//        self.videoWebView.load(videoRequest)
    }

    private func configurePostImages(to post: Post) {
//        imagesStackView.arrangedSubviews.enumerated().forEach { offset, view in
//            guard let imageView = view as? UIImageView,
//                  let postID = post.postID else { return }
//
//            let url = post.generatePostImageURL(for: postID, to: offset)
//            let path = postID + "_" + (offset + 1).description
//
//            imageView.setImagePostImage(to: url, key: path) { result in
//                switch result {
//                case .success:
//                    imageView.isHidden = false
//                case .failure:
//                    imageView.isHidden = true
//                }
//            }
//        }
    }
}

// Configure UI
private extension PostCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
//        configureLikeButtonAction()
        addGestureRecognizerToContentLabel()
//        addGestureRecognizerToCreatorNickNameLabel()
    }

    func configureHierarchy() {
//        [creatorImageView, creatorNickNameLabel].forEach(creatorStackView.addArrangedSubview)
//        imagesScrollView.addSubview(imagesStackView)
//        [videoWebView, imagesScrollView].forEach(postContentView.addSubview)
//        [likeButton, likeCountLabel, createdDateLabel].forEach(likeStackView.addArrangedSubview)
//        [creatorStackView, creatorUnderLineView, titleLabel, postContentView, contentLabel, contentUnderLineView,
//         likeStackView].forEach(stackView.addArrangedSubview)
//        outerView.addSubview(stackView)
//        contentView.addSubview(outerView)
        
        [titleLabel, contentLabel].forEach(contentStackView.addArrangedSubview(_:))
        
        [creatorHeaderView, contentStackView].forEach(contentView.addSubview(_:))
    }

    func configureConstraints() {
        creatorHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(creatorHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
//        [titleLabel, contentLabel].forEach {
//            $0.setContentHuggingPriority(.required, for: .vertical)
//        }
//        [likeButton, likeCountLabel].forEach {
//            $0.setContentHuggingPriority(.required, for: .horizontal)
//        }
//        postContentView.snp.makeConstraints {
//            $0.width.equalTo(postContentView.snp.height).priority(.required)
//        }
//        creatorImageView.snp.makeConstraints {
//            $0.width.height.equalTo(50).priority(.required)
//        }
//        [creatorUnderLineView, contentUnderLineView].forEach { lineView in
//            lineView.snp.makeConstraints { $0.height.equalTo(1) }
//        }
//        videoWebView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        imagesScrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        imagesStackView.snp.makeConstraints {
//            $0.edges.equalTo(imagesScrollView.contentLayoutGuide)
//        }
//        imagesStackView.arrangedSubviews.forEach { imageView in
//            imageView.snp.makeConstraints {
//                $0.width.equalTo(imagesScrollView.snp.width)
//                $0.height.equalTo(imagesScrollView.snp.height)
//            }
//        }
//        stackView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(10)
//        }
//        outerView.snp.makeConstraints() {
//            $0.top.bottom.equalToSuperview().inset(5)
//            $0.leading.trailing.equalToSuperview().inset(10)
//        }
    }

    func configureLikeButtonAction() {
//        likeButton.addAction(UIAction(handler: { [weak self] _ in
//            guard let postID = self?.postID else { return }
//            self?.delegate?.likeButtonTap(postID: postID)
//        }), for: .touchUpInside)
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
            self.contentLabel.numberOfLines = .zero
        })
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
    func performTableViewBathUpdates(_ updates: (() -> Void)?)
    func likeButtonTap(postID: String)
    func creatorNickNameLabelTap(creatorID: String)
}
