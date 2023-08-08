//
//  UploadLinkViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/03.
//

import UIKit
import LinkPresentation
import RxSwift

final class UploadLinkViewController: UIViewController {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.text = Constants.title
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    private let titleTextField = UnderLineTextField().then {
        $0.leadPadding(5)
        $0.placeholder = Constants.contentPlaceholder
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let titleStackView = UIStackView().then {
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .vertical
    }
    
    private let linkLabel = UILabel().then {
        $0.text = Constants.link
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    private let linkPreview = UploadLinkPreView()
    
    private let linkTextField = UnderLineTextField().then {
        $0.leadPadding(5)
        $0.placeholder = Constants.linkPlaceholder
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let linkStackView = UIStackView().then {
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let contentsLabel = UILabel().then {
        $0.text = Constants.content
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    private let contentsTextView = PostUploadContentTextView(placeHolder: Constants.contentPlaceholder)
        .then {
            $0.textView.textColor = .systemGray4
            $0.textView.font = UIFont.preferredFont(forTextStyle: .body)
        }
    
    private let contentsStackView = UIStackView().then {
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .vertical
    }
    
    private let contentView = UIView()
    private let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .interactive
        $0.showsVerticalScrollIndicator = false
    }
    
    // Properties
    weak var coordinator: UploadCoordinator?
    private let viewModel: UploadViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: UploadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavgationBar()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// Bind
extension UploadLinkViewController {
    func bind() {
        let output = bindingInput()
        
        navigationButtonBind()
        bindingKeyboardHeight()
        bindingView(output)
    }
    
    func bindingKeyboardHeight() {
        Observable.of(
            Notification.keyboardWillShow(),
            Notification.keyboardWillHide()
        )
        .merge()
        .asDriver(onErrorJustReturn: .zero)
        .drive {
            self.scrollView.contentInset.bottom = $0
        }
        .disposed(by: disposeBag)
    }
    
    func bindingView(_ output: UploadViewModel.Output) {
        output.post
            .asDriver(onErrorJustReturn: nil)
            .drive { self.configureInitState($0) }
            .disposed(by: disposeBag)
        
        output.post.compactMap { $0?.videoURL }
            .asDriver(onErrorJustReturn: "")
            .compactMap { URL(string: $0) }
            .drive {
                self.linkTextField.text = $0.description
                self.configureLinkView(url: $0)
            }
            .disposed(by: disposeBag)
        
        output.registerResult
            .observe(on: MainScheduler.instance)
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureInitState(_ post: Post?) {
        if let content = post?.content {
            self.contentsTextView.textView.text = content
            self.contentsTextView.textView.textColor = .label
        }
        
        self.titleTextField.text = post?.title
        self.linkTextField.text = post?.videoURL
    }
    
    func bindingInput() -> UploadViewModel.Output {
        let input = UploadViewModel.Input(registerButtonTap: configureRightButtonTapEvent())
        
        return viewModel.transform(input: input)
    }
    
    func configureRightButtonTapEvent() -> Observable<Upload> {
        guard let rightBarButton = navigationItem.rightBarButtonItem else {
            return .empty()
        }
        
        // UIComponent Contents Button Bind
        let isTitleNotEmpty = titleTextField.rx.observe(String.self, "text")
            .map { $0 != nil && $0?.count != .zero }
        
        let isContentNotEmpty = contentsTextView.textView.rx.text.orEmpty.map {
            return $0.isEmpty == false && $0 != Constants.contentPlaceholder
        }
        
        let isLinkNotEmpty = linkTextField.rx.observe(String.self, "text")
            .map { $0 != nil && $0?.count != .zero }
        
        Observable<Bool>.combineLatest(
            isTitleNotEmpty,
            isContentNotEmpty,
            isLinkNotEmpty,
            resultSelector: {
                return $0 && $1 && $2
            }
        )
        .bind(to: rightBarButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        return rightBarButton.rx.tap
            .map { _ in
                let upload = Upload(
                    title: self.titleTextField.text ?? "",
                    content: self.contentsTextView.textView.text,
                    imageDatas: [],
                    videoURL: self.linkTextField.text
                )
                return upload
            }
    }
    
    private func navigationButtonBind() {
        guard let leftBarButton = navigationItem.leftBarButtonItem else { return }
        leftBarButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// TextField Method & LinkView Display Method
extension UploadLinkViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var linkText = linkTextField.text else { return }
        if textField != linkTextField || linkText.isEmpty { return }
        
        if !linkText.contains(Constants.http) {
            linkText = Constants.http + linkText
            textField.text = linkText
        }
        
        guard let url = URL(string: linkText) else { return }
        
        configureLinkView(url: url)
    }
    
    private func configureLinkView(url: URL) {
        let metaDataProvider = LPMetadataProvider()
        
        metaDataProvider.startFetchingMetadata(for: url) { metaData, error in
            guard let metaData = metaData, error == nil else {
                self.configureDefaultLinkView()
                return
            }
            
            self.configureLinkView(metaData: metaData)
        }
    }
    
    private func configureLinkView(metaData: LPLinkMetadata) {
        let linkView = LPLinkView(metadata: metaData)
        
        DispatchQueue.main.async {
            self.linkPreview.showLinkView(linkView)
        }
    }
    
    private func configureDefaultLinkView() {
        DispatchQueue.main.async {
            self.linkPreview.showDefaultImage()
        }
    }
}

// TextView Delegate
extension UploadLinkViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.contentPlaceholder && textView.textColor == .systemGray4 {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Constants.contentPlaceholder
            textView.textColor = .systemGray4
        }
    }
}

// Configure UI
private extension UploadLinkViewController {
    func configureNavgationBar() {
        title = Constants.navigationTitle
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        
        let backLeftButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: nil
        )
        
        let uploadRightButton = UIBarButtonItem(
            title: Constants.register,
            style: .done,
            target: self,
            action: nil
        )
        
        navigationItem.leftBarButtonItem = backLeftButton
        navigationItem.rightBarButtonItem = uploadRightButton
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        configureTextFieldView()
        makeConstraints()
    }
    
    func configureTextFieldView() {
        contentsTextView.textView.delegate = self
        linkTextField.delegate = self
    }
    
    func configureHierarchy() {
        [linkLabel, linkPreview, linkTextField].forEach(linkStackView.addArrangedSubview(_:))
        [titleLabel, titleTextField].forEach(titleStackView.addArrangedSubview(_:))
        [contentsLabel, contentsTextView].forEach(contentsStackView.addArrangedSubview(_:))
        [titleStackView, linkStackView, contentsStackView].forEach(contentView.addSubview(_:))
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    func makeConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
            $0.height.equalTo(scrollView.frameLayoutGuide.snp.height).priority(.low)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        linkStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.top.equalTo(linkStackView).offset(16)
            $0.leading.trailing.equalTo(linkStackView)
            $0.bottom.equalToSuperview()
        }
        
        linkPreview.snp.makeConstraints {
            $0.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }
}

// Constants
private extension UploadLinkViewController {
    enum Constants {
        static let title = "제목"
        static let link = "링크"
        static let content = "내용"
        static let titlePlaceholder = "제목을 입력해주세요."
        static let linkPlaceholder = "링크를 입력해주세요."
        static let contentPlaceholder = "내용을 입력해주세요."
        static let navigationTitle = "게시물 작성"
        static let register = "완료"
        
        static let http = "https://"
    }
}
