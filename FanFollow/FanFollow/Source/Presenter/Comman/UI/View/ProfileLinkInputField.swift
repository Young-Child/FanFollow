//
//  ProfileLinkInputField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

class ProfileLinkInput: ProfileInputField {
    private var disposeBag = DisposeBag()
    
    override init(title: String) {
        super.init(title: title)
        
        textField.rx.text.orEmpty
            .bind(onNext: updateText(to:))
            .disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateText(to text: String) {
        let attribute: [NSAttributedString.Key: Any] = [
            .backgroundColor: UIColor.systemGray5,
            .foregroundColor: UIColor(named: "AccentColor") ?? .systemGray5
        ]
        
        let links = text.components(separatedBy: [" ", ","])
            .joined(separator: " ")
        
        let mutatingText = links.reduce(into: NSMutableAttributedString()) {
            let isSpace = ($1 == " "), value = String($1)
            
            let attribute = NSAttributedString(
                string: value,
                attributes: isSpace ? nil : attribute
            )
            
            $0.append(attribute)
        }
        
        self.textField.attributedText = mutatingText
    }
}

