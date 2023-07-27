//
//  UILabel+Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UILabel {
    func addCharacterSpacing(_ value: Double = 0.2) {
        let kernValue = self.font.pointSize * CGFloat(value)
        guard let text = text, !text.isEmpty else { return }
        
        let string = NSMutableAttributedString(string: text)
        let range = NSRange(location: .zero, length: string.length - 1)
        string.addAttribute(.kern, value: kernValue, range: range)
        attributedText = string
    }
}
