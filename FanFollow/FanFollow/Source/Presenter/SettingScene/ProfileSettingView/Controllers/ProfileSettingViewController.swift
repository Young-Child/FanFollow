//
//  ProfileSettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import PhotosUI

import Kingfisher
import RxSwift
import SnapKit

final class ProfileSettingViewController: UIViewController {
    // View Properties
    private let navigationBar = FFNavigationBar()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .interactive
    }
    
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 75
        $0.contentMode = .scaleAspectFill
    }
    
    private let profileInputStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.alignment = .center
        $0.spacing = 16
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let nickNameInput = ProfileInputField(title: Constants.Text.nickName)
    
    private let nickNameInformationLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 13, weight: .regular)
        $0.text = Constants.Text.nickNameInformationTitle
        $0.textColor = Constants.Color.grayDark
    }
    
    private let creatorInformationLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 13, weight: .regular)
        $0.text = Constants.Text.creatorInformationTitle
        $0.textColor = Constants.Color.blue
    }
    
    private let pickerView = JobCategoryPickerView()
    private let jobCategoryInput = ProfileInputField(title: Constants.Text.jobCategory)
    private let linkInput = ProfileLinkInput(title: Constants.Text.link)
    private let introduceInput = ProfileInputTextView(title: Constants.Text.introduce)
    
    // Properties
    weak var coordinator: ProfileSettingCoordinator?

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
}

// Binding Method
private extension ProfileSettingViewController {
    func binding() {
        bindingNavigationBar()
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
    
    func bindingNavigationBar() {
        navigationBar.leftBarButton.rx.tap
            .bind(onNext: {
                self.coordinator?.close(to: self)
            })
            .disposed(by: disposeBag)
    }
    
    func transformInput() -> ProfileSettingViewModel.Output {
        let viewWillAppear = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable()
        
        let input = ProfileSettingViewModel.Input(
            viewWillAppear: viewWillAppear,
            nickNameChanged: nickNameInput.textField.rx.text.orEmpty.asObservable(),
            categoryChanged: pickerView.rx.itemSelected.map(\.row).asObservable(),
            linksChanged: linkInput.textContainer.textView.rx.text
                .compactMap { $0 }.toArray().asObservable(),
            introduceChanged: introduceInput.textContainer.textView.rx.text.orEmpty.asObservable(),
            didTapUpdate: configureRightButtonTapEvent()
        )
        
        return viewModel.transform(input: input)
    }
    
    func bindingOutput(to output: ProfileSettingViewModel.Output) {
        output.profileURL
            .asDriver(onErrorJustReturn: ("", ""))
            .drive(onNext: { self.profileImageView.setImageProfileImage(to: $0.0, for: $0.1) })
            .disposed(by: disposeBag)
        
        output.nickName
            .asDriver(onErrorJustReturn: "")
            .drive(nickNameInput.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.isCreator
            .asDriver(onErrorJustReturn: false)
            .drive(
                jobCategoryInput.rx.isUserInteractionEnabled,
                linkInput.rx.isUserInteractionEnabled,
                introduceInput.rx.isUserInteractionEnabled
            )
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
        return navigationBar.rightBarButton.rx.tap
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

extension ProfileSettingViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        return numberOfChars <= 10
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
    
    @objc private func didTapImageChangeButton() {
        coordinator?.presentSelectImagePickerViewController()
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
        return UIBarButtonItem(title: Constants.Text.cancel, primaryAction: cancelAction)
    }
    
    func configureDoneButton(with pickerView: UIPickerView) -> UIBarButtonItem {
        let doneAction = UIAction { _ in
            let row = pickerView.selectedRow(inComponent: 0)
            let textFieldItem = JobCategory.allCases[row].categoryName
            
            self.jobCategoryInput.textField.text = textFieldItem
            self.jobCategoryInput.endEditing(true)
        }
        
        return UIBarButtonItem(title: Constants.Text.complete, primaryAction: doneAction)
    }
}

// Configure UI
private extension ProfileSettingViewController {
    func configureUI() {
        nickNameInput.textField.delegate = self
        view.backgroundColor = .systemBackground

        configureNavigationBar()
        configureHierarchy()
        configureCategoryPickerView()
        configureImageViewGesture()
        makeConstraints()
        
    }
    
    func configureNavigationBar() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22)
        let image = Constants.Image.back?.withConfiguration(configuration)
        
        navigationBar.leftBarButton.setImage(image, for: .normal)
        navigationBar.titleView.text = Constants.Text.profileEdit
        navigationBar.rightBarButton.setTitleColor(Constants.Color.blue, for: .normal)
        navigationBar.rightBarButton.setTitle(Constants.Text.complete, for: .normal)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func configureCategoryPickerView() {
        let toolbar = configureJobCategoryAccessoryView(with: pickerView)
        
        jobCategoryInput.configureInputView(to: pickerView, with: toolbar)
    }
    
    func configureHierarchy() {
        [navigationBar, scrollView].forEach(view.addSubview(_:))
        scrollView.addSubview(profileInputStackView)

        [
            profileImageView, nickNameInput, nickNameInformationLabel, creatorInformationLabel,
            jobCategoryInput, linkInput, introduceInput
        ].forEach(profileInputStackView.addArrangedSubview)
    }
    
    func makeConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Spacing.xLarge)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        profileInputStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }

        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }

        [nickNameInput, nickNameInformationLabel, creatorInformationLabel,
         jobCategoryInput, linkInput, introduceInput].forEach { view in
            view.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(Constants.Spacing.medium)
            }
        }
    }
}

extension ProfileSettingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
