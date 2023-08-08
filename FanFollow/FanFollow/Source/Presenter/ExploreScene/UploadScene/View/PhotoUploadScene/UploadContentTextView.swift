//
//  UploadContentTextView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

class PostUploadContentTextView: UnderLineTextView, PlaceHolderInput {
    var placeHolder: String
    private var disposeBag = DisposeBag()
    
    init(placeHolder: String) {
        self.placeHolder = placeHolder
        super.init()
        
        observeInput()
    }
    
    required init(coder: NSCoder) {
        self.placeHolder = ""
        super.init(coder: coder)
        
        observeInput()
    }
    
    func observeInput() {
        textView.rx.didBeginEditing
            .compactMap { _ in self.textView.text }
            .asDriver(onErrorJustReturn: "")
            .debug()
            .drive {
                if $0 == self.placeHolder {
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
                    self.textView.text = self.placeHolder
                    self.textView.textColor = .systemGray4
                }
            }
            .disposed(by: disposeBag)
    }
}
