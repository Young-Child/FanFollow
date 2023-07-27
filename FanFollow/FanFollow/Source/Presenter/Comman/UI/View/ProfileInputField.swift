//
//  ProfileInputField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxCocoa
import RxSwift
import Then
import SnapKit

class ProfileInput: UIStackView {
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = UIColor(named: "AccentColor")
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override var isUserInteractionEnabled: Bool {
        willSet {
            if newValue == false {
                self.titleLabel.textColor = .systemGray5
            }
        }
    }
}

private extension ProfileInput {
    func configureUI() {
        configureAttributes()
        configureHierarchy()
    }
    
    func configureHierarchy() {
        [titleLabel].forEach(addArrangedSubview)
    }
    
    func configureAttributes() {
        axis = .vertical
        distribution = .fillProportionally
        spacing = 8
        
        titleLabel.addCharacterSpacing()
    }
}

class ProfileInputTextView: ProfileInput {
    let textContainer = UnderLineTextView().then {
        $0.textView.font = .systemFont(ofSize: 17)
        $0.textView.autocapitalizationType = .none
        $0.textView.autocorrectionType = .no
        $0.textView.textAlignment = .left
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        
        configureUI()
        addArrangedSubview(textContainer)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class ProfileInputField: ProfileInput {
    let textField = UnderLineTextField().then {
        $0.font = .systemFont(ofSize: 17)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.textAlignment = .left
    }
    
    let textView = UnderLineTextView()
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        
        configureUI()
        addArrangedSubview(textField)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ProfileInputField {
    func configureInputView(to view: UIView, with accessoryView: UIView) {
        self.textField.inputView = view
        self.textField.inputAccessoryView = accessoryView
    }
}


