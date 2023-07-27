//
//  ProfileInputTextView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class ProfileInputTextView: ProfileInput {
    let textContainer = UnderLineTextView().then {
        $0.textView.font = .systemFont(ofSize: 17)
        $0.textView.autocapitalizationType = .none
        $0.textView.autocorrectionType = .no
        $0.textView.textAlignment = .left
    }
    
    override init(title: String) {
        super.init(title: title)
        addArrangedSubview(textContainer)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
