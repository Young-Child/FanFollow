//
//  ProfileLinkInputField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

class ProfileLinkInput: ProfileInputTextView {
    private var disposeBag = DisposeBag()
    
    override init(title: String) {
        super.init(title: title)
        
        textContainer.textView.rx.text.orEmpty
            .bind(onNext: updateText(to:))
            .disposed(by: disposeBag)
        
        textContainer.textView.keyboardType = .webSearch
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateText(to text: String) {
        let links = text.components(separatedBy: [" ", ","])
            .joined(separator: " ")
        
        let mutatingText = generateLinkAttributeString(links: links)
        addParagraphStyle(to: mutatingText)

        textContainer.textView.attributedText = mutatingText
    }
}

extension ProfileLinkInput {
    private func generateLinkAttributeString(links: String) -> NSMutableAttributedString {
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .backgroundColor: Constants.Color.gray,
            .foregroundColor: Constants.Color.blue
        ]
        
        return links.reduce(into: NSMutableAttributedString()) {
            let isSpace = ($1 == " ")

            let attribute = NSAttributedString(
                string: String($1),
                attributes: isSpace ? nil : attribute
            )

            $0.append(attribute)
        }
    }
    
    private func addParagraphStyle(to mutatingText: NSMutableAttributedString) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 12
        
        mutatingText.addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: mutatingText.string.count)
        )
    }
}
