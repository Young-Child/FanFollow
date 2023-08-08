//
//  UploadLinkViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/03.
//

import UIKit
import LinkPresentation
import RxSwift

final class UploadLinkViewController: UploadViewController {
    // View Properties
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
    
    private let linkPreview = UploadLinkPreview()
    
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
    
    private let contentsStackView = UIStackView().then {
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .vertical
    }
    
    // Properties
    private let disposeBag = DisposeBag()
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func bindingOutput(_ output: UploadViewModel.Output) {
        super.bindingOutput(output)
        
        output.post.compactMap { $0?.videoURL }
            .asDriver(onErrorJustReturn: "")
            .compactMap { URL(string: $0) }
            .drive {
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [linkLabel, linkPreview, linkTextField].forEach(linkStackView.addArrangedSubview(_:))
        [titleLabel, titleTextField].forEach(titleStackView.addArrangedSubview(_:))
        [contentsLabel, contentsTextView].forEach(contentsStackView.addArrangedSubview(_:))
        [titleStackView, linkStackView, contentsStackView].forEach(contentView.addSubview(_:))
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        linkStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.top.equalTo(linkStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(linkStackView)
            $0.bottom.equalToSuperview()
        }
        
        linkPreview.snp.makeConstraints {
            $0.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }
    
    override func binding() {
        super.binding()
        
        let output = bindingInput()
        bindingOutput(output)
    }
}

// Bind
extension UploadLinkViewController {
    func bindingInput() -> UploadViewModel.Output {
        let input = UploadViewModel.Input(registerButtonTap: configureRightButtonTapEvent())
        
        return viewModel.transform(input: input)
    }
    
    func configureInitState(_ post: Post?) {
        if let content = post?.content {
            self.contentsTextView.textView.text = content
            self.contentsTextView.textView.textColor = .label
        }
        
        self.titleTextField.text = post?.title
        self.linkTextField.text = post?.videoURL
    }
    
    func configureRightButtonTapEvent() -> Observable<Upload> {
        guard let rightBarButton = navigationItem.rightBarButtonItem else { return .empty() }
        
        bindingRightBarButton(with: rightBarButton)

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
    
    func bindingRightBarButton(with barButton: UIBarButtonItem) {
        let isTitleNotEmpty = titleTextField.rx.observe(String.self, "text")
            .map { $0?.count != .zero && $0 != nil }
        
        let isLinkNotEmpty = linkTextField.rx.observe(String.self, "text")
            .map { $0 != nil && $0?.count != .zero }
        
        let isContentNotEmpty = contentsTextView.textView.rx.text.orEmpty.map {
            return $0.isEmpty == false && $0 != Constants.contentPlaceholder
        }
        
        Observable.combineLatest(isTitleNotEmpty, isLinkNotEmpty, isContentNotEmpty) {
            $0 && $1 && $2
        }
        .bind(to: barButton.rx.isEnabled)
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
        
        linkPreview.setLink(to: url)
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
extension UploadLinkViewController {
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
