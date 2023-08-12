//
//  Font.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UIFont {
    enum CoreDreamWeight: Int, CustomStringConvertible {
        case thin = 1
        case extraLight
        case light
        case regular
        case medium
        case bold
        case extraBold
        case heavy
        case black
        
        var description: String {
            switch self {
            case .thin:             return "Thin"
            case .extraLight:       return "ExtraLight"
            case .light:            return "Light"
            case .regular:          return "Regular"
            case .medium:           return "Medium"
            case .bold:             return "Bold"
            case .extraBold:        return "ExtraBold"
            case .heavy:            return "Heavy"
            case .black:            return "Black"
            }
        }
        
        static let baseName: String = "S-CoreDream-"
        
        var fontName: String {
            return Self.baseName + self.rawValue.description + self.description
        }
    }
    
    static func coreDreamFont(ofSize fontSize: CGFloat, weight fontType: CoreDreamWeight) -> UIFont? {
        let fontName = fontType.fontName
        return UIFont(name: fontName, size: fontSize)
    }
}
