//
//  UnderLineTextField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class UnderLineTextField: UITextField {
    private let underLineLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = Constants.Color.gray.cgColor
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underLineLayer.frame = CGRect(
            x: 0,
            y: frame.size.height + 5,
            width: self.frame.width,
            height: 1
        )
        layer.addSublayer(underLineLayer)
        
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

class UnderLineTextView: UIStackView {
    let textView = UITextView().then {
        $0.isScrollEnabled = false
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let underLine = UIView().then {
        $0.layer.borderColor = Constants.Color.gray.cgColor
        $0.layer.borderWidth = 1
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = Constants.Color.clear
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = .zero
        
        
        underLine.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        textView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(80)
        }
        
        [textView, underLine].forEach(addArrangedSubview(_:))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PlaceholderInput {
    var placeholder: String? { get set }
    func observeInput()
}
