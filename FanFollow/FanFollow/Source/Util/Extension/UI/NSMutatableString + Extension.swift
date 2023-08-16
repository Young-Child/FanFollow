//
//  NSMutatableString + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension NSMutableAttributedString {
    func regular(_ value: String) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: value))
        return self
    }
    
    func highlight(_ value: String, to color: UIColor?) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
