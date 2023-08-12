//
//  UploadViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class UploadViewController: UIViewController {
    let titleLabel = UILabel().then {
        $0.text = ConstantsUpload.title
        $0.font = .coreDreamFont(ofSize: 22, weight: .bold)
    }
    
    let titleTextField = UnderLineTextField().then {
        $0.leadPadding(5)
        $0.placeholder = ConstantsUpload.titlePlaceholder
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    let contentsLabel = UILabel().then {
        $0.text = ConstantsUpload.content
        $0.font = .coreDreamFont(ofSize: 22, weight: .bold)
    }
    
    let contentsTextView = PostUploadContentTextView(
        placeHolder: ConstantsUpload.contentPlaceholder
    ).then {
        $0.textView.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    let contentView = UIView()
    
    let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .interactive
        $0.showsVerticalScrollIndicator = false
    }
    
    weak var coordinator: UploadCoordinator?
    let viewModel: UploadViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: UploadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addKeyBoardGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding() {
        bindingLeftButton()
        bindingKeyboardHeight()
    }
    
    func bindingKeyboardHeight() {
        Observable.merge([Notification.keyboardWillShow(), Notification.keyboardWillHide()])
            .asDriver(onErrorJustReturn: .zero)
            .drive {
                self.scrollView.contentInset.bottom = $0
            }
            .disposed(by: disposeBag)
    }
    
    // Binding Method
    func bindingOutput(_ output: UploadViewModel.Output) {
        let post = output.post.asDriver(onErrorJustReturn: nil)
        
        post.compactMap { $0?.title }
            .drive(titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        post.compactMap { $0?.content }
            .drive(onNext: contentsTextView.setInitialState(to:))
            .disposed(by: disposeBag)
        
        output.registerResult
            .asDriver(onErrorJustReturn: ())
            .drive { _ in self.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
    }
    
    func bindingLeftButton() {
        guard let leftBarButton = navigationItem.leftBarButtonItem else { return }
        
        leftBarButton.rx.tap
            .bind { self.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
    }
    
    func configureNavigationBar() {
        view.backgroundColor = .systemBackground

        title = ConstantsUpload.navigationTitle
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        
        let popButton = UIBarButtonItem(image: Constants.Image.back)
        let uploadButton = UIBarButtonItem(title: ConstantsUpload.register)
        
        navigationItem.leftBarButtonItem = popButton
        navigationItem.rightBarButtonItem = uploadButton
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
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
        }
    }
    
    func addKeyBoardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapKeyboardDismiss)
        )
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapKeyboardDismiss() {
        self.view.endEditing(true)
    }
}

// Constants
private extension UploadViewController {
    enum ConstantsUpload {
        static let title = "제목"
        static let content = "내용"
        static let titlePlaceholder = "제목을 입력해주세요."
        static let contentPlaceholder = "내용을 입력해주세요."
        static let navigationTitle = "게시물 작성"
        static let register = "완료"
    }
}
