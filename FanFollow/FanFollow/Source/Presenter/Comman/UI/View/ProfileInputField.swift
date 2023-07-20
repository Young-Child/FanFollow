//
//  ProfileInputField.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxCocoa
import RxSwift
import Then
import SnapKit

final class ProfileInputField: UIStackView {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = UIColor(named: "AccentColor")
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let textField = UnderLineTextField().then {
        $0.font = .systemFont(ofSize: 17)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.textAlignment = .left
    }
    
    private var disposeBag = DisposeBag()
    var prevText: String = ""
    
    init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        
        configureAttributes()
        configureUI()
        
        textField.rx.text.orEmpty
            .bind(to: self.rx.prevText)
            .disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ProfileInputField {
    func configureInputView(to view: UIView, with accessoryView: UIView) {
        self.textField.inputView = view
        self.textField.inputAccessoryView = accessoryView
    }
}

private extension ProfileInputField {
    func configureUI() {
        configureHierarchy()
    }
    
    func configureHierarchy() {
        [titleLabel, textField].forEach(addArrangedSubview)
    }
    
    func configureAttributes() {
        axis = .vertical
        distribution = .fillProportionally
        spacing = 8
        
        titleLabel.addCharacterSpacing()
    }
}
