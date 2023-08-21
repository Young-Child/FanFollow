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
    let navigationBar = FFNavigationBar()
    
    let titleLabel = UILabel().then {
        $0.text = Constants.Text.title
        $0.font = .coreDreamFont(ofSize: 22, weight: .bold)
    }
    
    let titleTextField = UnderLineTextField().then {
        $0.leadPadding(5)
        $0.placeholder = Constants.Text.titlePlaceholder
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
    }
    
    let contentsLabel = UILabel().then {
        $0.text = Constants.Text.content
        $0.font = .coreDreamFont(ofSize: 22, weight: .bold)
    }
    
    let contentsTextView = PostUploadContentTextView(
        placeHolder: Constants.Text.contentPlaceholder
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
    }
    
    func bindingLeftButton() {
        navigationBar.leftBarButton.rx.tap
            .bind(onNext: {
                self.coordinator?.close(to: self)
            })
            .disposed(by: disposeBag)
    }
    
    func configureNavigationBar() {
        view.backgroundColor = .systemBackground
        
        navigationBar.leftBarButton.setImage(Constants.Image.back, for: .normal)
        navigationBar.titleView.text = Constants.Text.registerPost
        navigationBar.rightBarButton.setTitleColor(Constants.Color.blue, for: .normal)
        navigationBar.rightBarButton.setTitleColor(Constants.Color.grayDark, for: .disabled)
        navigationBar.rightBarButton.setTitle(Constants.Text.complete, for: .normal)
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        scrollView.addSubview(contentView)
        [navigationBar, scrollView].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
