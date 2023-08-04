//
//  CreatorApplicationTextFieldCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

final class CreatorApplicationTextFieldCell: UITableViewCell {
    private let stackView = UIStackView().then { stackView in
        stackView.spacing = 8
    }

    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    private let textField = UnderLineTextField().then { textField in
        textField.textColor = UIColor(named: "AccentColor")
        textField.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private var onTextChanged: ((String?) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
        textField.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTextChanged?(self.textField.text)
        }), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        title: String?,
        text: String? = nil,
        keyboardType: UIKeyboardType = .default,
        onTextChanged: ((String?) -> Void)? = nil) {
            titleLabel.text = title
            textField.text = text
            textField.keyboardType = keyboardType
            self.onTextChanged = onTextChanged
    }
}

private extension CreatorApplicationTextFieldCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
    }

    func configureHierarchy() {
        [titleLabel, textField].forEach(stackView.addArrangedSubview)
        contentView.addSubview(stackView)
    }

    func configureConstraints() {
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
