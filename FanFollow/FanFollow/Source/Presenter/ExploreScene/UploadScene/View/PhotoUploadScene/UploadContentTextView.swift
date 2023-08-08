//
//  UploadContentTextView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

class PostUploadContentTextView: UnderLineTextView, PlaceholderInput {
    var placeholder: String? = nil
    private var disposeBag = DisposeBag()
    
    init(placeHolder: String? = nil) {
        self.placeholder = placeHolder
        super.init()
        
        self.textView.text = placeholder
        self.textView.textColor = .systemGray4
        
        observeInput()
    }
    
    required init(coder: NSCoder) {
        self.placeholder = ""
        super.init(coder: coder)
        
        observeInput()
    }
    
    func observeInput() {
        textView.rx.didBeginEditing
            .subscribe(onNext: { [self] in
                if textView.text == self.placeholder {
                    textView.text = nil
                    textView.textColor = .label
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: { [self] in
                let newText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                textView.text = newText
                if textView.text == nil || textView.text == "" {
                    self.textView.text = self.placeholder
                    textView.textColor = .systemGray4
                }
            })
            .disposed(by: disposeBag)
    }
}
