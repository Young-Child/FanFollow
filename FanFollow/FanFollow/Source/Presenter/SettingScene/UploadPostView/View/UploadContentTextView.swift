//
//  UploadContentTextView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

protocol PlaceholderInput {
    var placeholder: String? { get set }
    func observeInput()
}

class PostUploadContentTextView: UnderLineTextView, PlaceholderInput {
    var placeholder: String?
    private var disposeBag = DisposeBag()
    
    init(placeHolder: String? = nil) {
        self.placeholder = placeHolder
        super.init()
        
        self.textView.text = placeHolder
        self.textView.textColor = Constants.Color.gray
        
        observeInput()
    }
    
    required init(coder: NSCoder) {
        self.placeholder = ""
        super.init(coder: coder)
        
        observeInput()
    }
    
    func observeInput() {
        textView.rx.didBeginEditing
            .map { _ in return self.textView.text }
            .subscribe(onNext: setTextViewLabel(to:))
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .map { _ in return self.textView.text }
            .subscribe(onNext: self.setTextViewPlaceholder(to:))
            .disposed(by: disposeBag)
    }
    
    func setInitialState(to text: String) {
        self.textView.text = text
        self.textView.textColor = Constants.Color.label
    }
    
    private func setTextViewPlaceholder(to text: String?) {
        let newText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newText == nil || newText == "" {
            textView.text = placeholder
            textView.textColor = Constants.Color.gray
        }
    }
    
    private func setTextViewLabel(to text: String?) {
        if text == self.placeholder {
            textView.text = nil
            textView.textColor = Constants.Color.label
        }
    }
}
