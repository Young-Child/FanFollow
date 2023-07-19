//
//  ProfileSettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import SnapKit

final class ProfileSettingViewController: UIViewController {
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "ExampleProfile")
    }
    
    private let nickNameInput = ProfileInputField(title: "닉네임")
    private let emailInput = ProfileInputField(title: "이메일")
    
    private let creatorInformationLabel = UILabel().then {
        $0.text = "소개 및 상세 정보는 크리에이터만 수정할 수 있습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = UIColor(named: "AccentColor")
    }
    
    private let jobCategoryInput = ProfileInputField(title: "분야")
    private let linkInput = ProfileInputField(title: "링크")
    private let introduceInput = ProfileInputField(title: "소개")
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

extension ProfileSettingViewController {
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
            
            self.jobCategoryInput.setText(with: textFieldItem)
            self.jobCategoryInput.endEditing(true)
        }
        
        return UIBarButtonItem(title: "완료", primaryAction: doneAction)
    }
}

// Configure UI
private extension ProfileSettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        configureHierarchy()
        configureCategoryPickerView()
        makeConstraints()
    }
    
    func configureCategoryPickerView() {
        let pickerView = JobCategoryPickerView()
        let toolbar = configureJobCategoryAccessoryView(with: pickerView)
        
        jobCategoryInput.configureInputView(to: pickerView, with: toolbar)
    }
    
    func configureHierarchy() {
        [
            profileImageView,
            nickNameInput,
            emailInput,
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
            $0.width.equalTo(100).priority(.high)
            $0.height.equalTo(100).priority(.high)
        }
        
        nickNameInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.height.equalTo(50)
        }
        
        emailInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(nickNameInput.snp.bottom).offset(24)
            $0.height.equalTo(50)
        }
        
        creatorInformationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(emailInput.snp.bottom).offset(32)
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
