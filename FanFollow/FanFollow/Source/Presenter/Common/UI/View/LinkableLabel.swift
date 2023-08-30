//
//  LinkableLabel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UILabel {
    static func configureAuthInformationLabel() -> UILabel {
        let label = UILabel().then {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        let generalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Constants.Color.label,
            .font: UIFont.coreDreamFont(ofSize: 14, weight: .light) as Any
        ]
        
        let agree = Constants.Text.agreementName
        let privacyName = Constants.Text.privacyName
        
        let generalText = String(
            format: Constants.Text.privacyFormat,
            agree,
            privacyName
        )
        
        let mutableString = NSMutableAttributedString()
        
        mutableString.append(
            NSAttributedString(
                string: generalText,
                attributes: generalAttributes
            )
        )
        
        mutableString.setAttributes(
            linkAttributes,
            range: (generalText as NSString).range(of: agree)
        )
        
        mutableString.setAttributes(
            linkAttributes,
            range: (generalText as NSString).range(of: privacyName)
        )
        
        label.attributedText = mutableString
        return label
    }
    
    static var linkAttributes: [NSAttributedString.Key: Any] {
        return [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: Constants.Color.grayDark,
            .font: UIFont.coreDreamFont(ofSize: 14, weight: .light) as Any
        ]
    }
    
    // 라벨 내 특정 문자열의 Rect를 반화
    func boundingRectForCharacterRange(subText: String) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        guard let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        
        // 전체 텍스트(text)에서 subText만큼의 range를 구합니다.
        guard let subRange = text.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: text)
        
        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가합니다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // instrinsicContentSize를 기반으로 NSTextContainer를 선언하고
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 줍니다.
        textContainer.lineFragmentPadding = 0.0
        
        // layoutManager에 추가합니다.
        layoutManager.addTextContainer(textContainer)
        var glyphRange = NSRange()
        
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구합니다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )
        
        // textContainer 내의 지정된 glyphRange에 대한 CGRect 값을 반환합니다.
        return layoutManager.boundingRect(
            forGlyphRange: glyphRange,
            in: textContainer
        )
    }
}
