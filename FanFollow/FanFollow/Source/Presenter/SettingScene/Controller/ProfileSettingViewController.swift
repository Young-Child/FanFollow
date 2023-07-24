//
//  ProfileSettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import PhotosUI

import RxSwift
import SnapKit

final class ProfileSettingViewController: UIViewController {
    // View Properties
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 75
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "ExampleProfile")
    }
    
    private let nickNameInput = ProfileInputField(title: "닉네임")
    
    private let creatorInformationLabel = UILabel().then {
        $0.text = "소개 및 상세 정보는 크리에이터만 수정할 수 있습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = UIColor(named: "AccentColor")
    }
    
    private let pickerView = JobCategoryPickerView()
    private let jobCategoryInput = ProfileInputField(title: "분야")
    private let linkInput = ProfileInputField(title: "링크")
    private let introduceInput = ProfileInputField(title: "소개")
    
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
        let output = transformInput()
        bindingOutput(to: output)
    }
    
    func transformInput() -> ProfileSettingViewModel.Output {
        let viewWillAppear = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable()
        
        let input = ProfileSettingViewModel.Input(
            viewWillAppear: viewWillAppear,
            nickNameChanged: nickNameInput.textField.rx.text.orEmpty.asObservable(),
            categoryChanged: pickerView.rx.itemSelected.map(\.row).asObservable(),
            linksChanged: linkInput.textField.rx.text.compactMap { $0 }.toArray().asObservable(),
            introduceChanged: introduceInput.textField.rx.text.orEmpty.asObservable(),
            didTapUpdate: configureRightButtonTapEvent()
        )
        
        return viewModel.transform(input: input)
    }
    
    func bindingOutput(to output: ProfileSettingViewModel.Output) {
        output.nickName
            .debug()
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
        
        output.links
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
            .map { $0.joined(separator: ",") }
            .drive(linkInput.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.introduce
            .asDriver(onErrorJustReturn: nil)
            .drive(introduceInput.textField.rx.text)
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
                    self.linkInput.textField.text?.components(separatedBy: ","),
                    self.introduceInput.textField.text
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
    
    @objc private func didTapImageChangeButton() {
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
        
        navigationController?.navigationBar.topItem?.title = "뒤로"
    }
    
    func configureCategoryPickerView() {
        let toolbar = configureJobCategoryAccessoryView(with: pickerView)
        
        jobCategoryInput.configureInputView(to: pickerView, with: toolbar)
    }
    
    func configureHierarchy() {
        [
            profileImageView,
            nickNameInput,
            creatorInformationLabel,
            jobCategoryInput,
            linkInput,
            introduceInput
        ].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.width.equalTo(150).priority(.high)
            $0.height.equalTo(150).priority(.high)
        }
        
        nickNameInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.height.equalTo(50)
        }
        
        creatorInformationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(nickNameInput.snp.bottom).offset(32)
        }
        
        jobCategoryInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(creatorInformationLabel.snp.bottom).offset(16)
        }
        
        linkInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(jobCategoryInput.snp.bottom).offset(32)
        }
        
        introduceInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(linkInput.snp.bottom).offset(32)
        }
    }
}

final class ImagePickerViewController: UIImagePickerController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.dismiss(animated: true) {
            let image = info[.editedImage] as? UIImage
//            self.profileImageView.image = image
        }
    }
}

extension ImagePickerViewController: UINavigationControllerDelegate {
    
}
