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
        
        observeInput()
    }
    
    required init(coder: NSCoder) {
        self.placeholder = ""
        super.init(coder: coder)
        
        observeInput()
    }
    
    func observeInput() {
        textView.rx.didBeginEditing
            .compactMap { _ in self.textView.text }
            .asDriver(onErrorJustReturn: "")
            .debug()
            .drive {
                if $0 == self.placeholder {
                    self.textView.text = nil
                    self.textView.textColor = .label
                }
            }
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .compactMap { _ in self.textView.text }
            .asDriver(onErrorJustReturn: "")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .drive {
                if $0 {
                    self.textView.text = self.placeholder
                    self.textView.textColor = .systemGray4
                }
            }
            .disposed(by: disposeBag)
    }
}
