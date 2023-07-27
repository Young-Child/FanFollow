//
//  ProfileSettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.
<<<<<<< HEAD

import UIKit
import PhotosUI

import RxSwift
import SnapKit
import Kingfisher

final class ProfileSettingViewController: UIViewController {
    // View Properties
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .interactive
    }
    private let scrollViewContentView = UIView()
    
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 75
        $0.contentMode = .scaleAspectFill
    }
    
    private let profileInputStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.alignment = .fill
        $0.spacing = 16
        $0.distribution = .fillProportionally
        $0.axis = .vertical
    }
    
    private let nickNameInput = ProfileInputField(title: "닉네임")
    
    private let creatorInformationLabel = UILabel().then {
        $0.text = "소개 및 상세 정보는 크리에이터만 수정할 수 있습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = UIColor(named: "AccentColor")
    }
    
    private let pickerView = JobCategoryPickerView()
    private let jobCategoryInput = ProfileInputField(title: "분야")
    private let linkInput = ProfileLinkInput(title: "링크")
    private let introduceInput = ProfileInputTextView(title: "소개")
    
    private var viewModel: ProfileSettingViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: ProfileSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// Binding Method
private extension ProfileSettingViewController {
    func binding() {
        bindingKeyboardHeight()
        let output = transformInput()
        bindingOutput(to: output)
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
    
    func transformInput() -> ProfileSettingViewModel.Output {
        let viewWillAppear = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable()
        
        let input = ProfileSettingViewModel.Input(
            viewWillAppear: viewWillAppear,
            nickNameChanged: nickNameInput.textField.rx.text.orEmpty.asObservable(),
            categoryChanged: pickerView.rx.itemSelected.map(\.row).asObservable(),
            linksChanged: linkInput.textContainer.textView.rx.text.compactMap { $0 }.toArray().asObservable(),
            introduceChanged: introduceInput.textContainer.textView.rx.text.orEmpty.asObservable(),
            didTapUpdate: configureRightButtonTapEvent()
        )
        
        return viewModel.transform(input: input)
    }
    
    func bindingOutput(to output: ProfileSettingViewModel.Output) {
        output.profileURL
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: setImage)
            .disposed(by: disposeBag)
        
        output.nickName
            .asDriver(onErrorJustReturn: "")
            .drive(nickNameInput.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.isCreator
            .asDriver(onErrorJustReturn: true)
            .drive(jobCategoryInput.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        output.isCreator
            .asDriver(onErrorJustReturn: true)
            .drive(linkInput.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        output.isCreator
            .asDriver(onErrorJustReturn: true)
            .drive(introduceInput.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        output.jobCategory.compactMap { $0?.rawValue }
            .asDriver(onErrorJustReturn: Int.zero)
            .map { ($0, 0, true) }
            .drive(onNext: pickerView.selectRow)
            .disposed(by: disposeBag)
        
        output.jobCategory
            .compactMap { $0?.categoryName }
            .asDriver(onErrorJustReturn: "")
            .drive(jobCategoryInput.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.links
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
            .map { $0.joined(separator: ",") }
            .drive(onNext: linkInput.updateText(to:))
            .disposed(by: disposeBag)
        
        output.introduce
            .asDriver(onErrorJustReturn: nil)
            .drive(introduceInput.textContainer.textView.rx.text)
            .disposed(by: disposeBag)
        
        output.updateResult
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureRightButtonTapEvent() -> Observable<(String?, Int, [String]?, String?)> {
        guard let rightButton = navigationItem.rightBarButtonItem else {
            return .empty()
        }
        
        return rightButton.rx.tap
            .map { _ in
                return (
                    self.nickNameInput.textField.text ?? "",
                    self.pickerView.selectedRow(inComponent: .zero),
                    self.linkInput.textContainer.textView.text?.components(separatedBy: ","),
                    self.introduceInput.textContainer.textView.text
                )
            }
            .asObservable()
    }
}

private extension ProfileSettingViewController {
    func configureImageViewGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImageChangeButton)
        )
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setImage(to url: String) {
        self.profileImageView.setImageProfileImage(to: url)
    }
    
    @objc private func didTapImageChangeButton() {
        let viewModel = ProfileImagePickerViewModel(
            userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
            profileImageUploadUseCase: DefaultUpdateProfileImageUseCase(
                imageRepository: DefaultImageRepository(
                    network: DefaultNetworkService()
                )
            )
        )
        
        let imagePickerViewController = ProfileImagePickerViewController(viewModel: viewModel)
        
        let controller = UINavigationController(rootViewController: imagePickerViewController)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
}

// Configure Category Accessory View Configure Method
private extension ProfileSettingViewController {
    func configureJobCategoryAccessoryView(with pickerView: UIPickerView) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems(
            [
                configureCancelButton(),
                space, configureDoneButton(with: pickerView)
            ],
            animated: true
        )
        
        return toolbar
    }
    
    func configureCancelButton() -> UIBarButtonItem {
        let cancelAction = UIAction { _ in self.jobCategoryInput.endEditing(true) }
        return UIBarButtonItem(title: "취소", primaryAction: cancelAction)
    }
    
    func configureDoneButton(with pickerView: UIPickerView) -> UIBarButtonItem {
        let doneAction = UIAction { _ in
            let row = pickerView.selectedRow(inComponent: 0)
            let textFieldItem = JobCategory.allCases[row].categoryName
            
            self.jobCategoryInput.textField.text = textFieldItem
            self.jobCategoryInput.endEditing(true)
        }
        
        return UIBarButtonItem(title: "완료", primaryAction: doneAction)
    }
}

// Configure UI
private extension ProfileSettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        configureHierarchy()
        configureCategoryPickerView()
        configureImageViewGesture()
        makeConstraints()
        
    }
    
    func configureNavigationBar() {
        let completeButton = UIBarButtonItem(title: "완료")
        navigationItem.rightBarButtonItem = completeButton
        navigationItem.title = "프로필 편집"
        navigationController?.navigationBar.topItem?.title = "뒤로"
    }
    
    func configureCategoryPickerView() {
        let toolbar = configureJobCategoryAccessoryView(with: pickerView)
        
        jobCategoryInput.configureInputView(to: pickerView, with: toolbar)
    }
    
    func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContentView)
        
        [
            nickNameInput, creatorInformationLabel,
            jobCategoryInput, linkInput, introduceInput
        ].forEach(profileInputStackView.addArrangedSubview)
        
        [profileImageView, profileInputStackView].forEach(scrollViewContentView.addSubview(_:))
    }
    
    func makeConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollViewContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
            $0.height.equalTo(scrollView.frameLayoutGuide.snp.height).priority(.high)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        profileInputStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
=======
        

import Foundation
>>>>>>> c291a9f (config : scene 밑 Controller 폴더 생성 및 ProfileSettingViewCOntroller 파일 생성)
