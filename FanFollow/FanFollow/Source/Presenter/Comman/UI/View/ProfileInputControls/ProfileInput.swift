//
//  ProfileInput.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class ProfileInput: UIStackView {
    let titleLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 20, weight: .medium)
        $0.textColor = Constants.Color.blue
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override var isUserInteractionEnabled: Bool {
        willSet {
            if newValue == false {
                self.titleLabel.textColor = .systemGray5
            }
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileInput {
    func configureUI() {
        configureAttributes()
        configureHierarchy()
    }
    
    func configureHierarchy() {
        [titleLabel].forEach(addArrangedSubview)
    }
    
    func configureAttributes() {
        axis = .vertical
        distribution = .fillProportionally
        spacing = 8
        
        titleLabel.addCharacterSpacing()
    }
}
