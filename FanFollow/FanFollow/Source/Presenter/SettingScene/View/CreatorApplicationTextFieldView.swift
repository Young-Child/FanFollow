//
//  CreatorApplicationTextFieldView.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/02.
//

import UIKit

final class CreatorApplicationTextFieldView: UIView {
    // View Properties
    private let stackView = UIStackView().then { stackView in
        stackView.spacing = 8
    }

    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    private let textField = UnderLineTextField().then { textField in
        textField.textColor = Constants.Color.blue
        textField.font = .systemFont(ofSize: 14, weight: .regular)
    }

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Configure UI
private extension CreatorApplicationTextFieldView {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
    }

    func configureHierarchy() {
        [titleLabel, textField].forEach(stackView.addArrangedSubview)
        addSubview(stackView)
    }

    func configureConstraints() {
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
