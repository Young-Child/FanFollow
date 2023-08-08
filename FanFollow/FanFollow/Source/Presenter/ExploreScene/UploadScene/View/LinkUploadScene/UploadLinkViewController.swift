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
    
    private let linkTextView = PostUploadContentTextView(
        placeHolder: Constants.linkPlaceholder
    ).then {
        $0.textView.font = .preferredFont(forTextStyle: .body)
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
    
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [linkLabel, linkPreview, linkTextView].forEach(linkStackView.addArrangedSubview(_:))
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
        
        bindingViews()
        let output = bindingInput()
        bindingOutput(output)
    }
    
    override func bindingOutput(_ output: UploadViewModel.Output) {
        super.bindingOutput(output)
        
        output.post.compactMap { $0?.videoURL }
            .asDriver(onErrorJustReturn: "")
            .drive(linkTextView.textView.rx.text)
            .disposed(by: disposeBag)
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
        self.linkTextView.textView.text = post?.videoURL
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
                    videoURL: self.linkTextView.textView.text ?? ""
                )
                return upload
            }
    }
    
    func bindingViews() {
        linkTextView.textView.rx.text.orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: {
                var urlString = $0
                if urlString.hasPrefix(Constants.http) == false {
                    urlString = Constants.http + urlString
                }
                guard let url = URL(string: urlString) else { return }
                self.linkPreview.setLink(to: url)
            })
            .disposed(by: disposeBag)
    }
    
    func bindingRightBarButton(with barButton: UIBarButtonItem) {
        let isTitleNotEmpty = titleTextField.rx.observe(String.self, "text")
            .map { $0?.count != .zero && $0 != nil }
        
        let isLinkNotEmpty = linkTextView.textView.rx.text.orEmpty
            .map { $0.isEmpty == false && $0 != Constants.linkPlaceholder }
        
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


// Configure UI
extension UploadLinkViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
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
