//
//  Notification + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

extension Notification {
    static func keyboardWillShow() -> Observable<CGFloat> {
        return NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] }
            .map { ($0 as? NSValue)?.cgRectValue.height ?? .zero }
            .asObservable()
    }
    
    static func keyboardWillHide() -> Observable<CGFloat> {
        return NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ in return .zero }
            .asObservable()
    }
}
