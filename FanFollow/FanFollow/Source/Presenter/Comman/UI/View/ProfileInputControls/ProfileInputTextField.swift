//
//  ProfileInputTextField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class ProfileInputField: ProfileInput {
    let textField = UnderLineTextField().then {
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.textAlignment = .left
    }
    
    let textView = UnderLineTextView()
    
    override init(title: String) {
        super.init(title: title)
        
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
