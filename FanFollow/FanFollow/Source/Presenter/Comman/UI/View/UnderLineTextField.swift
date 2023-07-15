//
//  UnderLineTextField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class UnderLineTextField: UITextField {
    private let underLineLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underLineLayer.frame = CGRect(
            x: 0,
            y: frame.size.height + 2,
            width: self.frame.width,
            height: 2
        )
        layer.addSublayer(underLineLayer)
    }
}
