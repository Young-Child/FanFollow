//
//  ButtonCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

final class ButtonCell: UITableViewCell {
    private let button = UIButton(type: .roundedRect).then { button in
        button.layer.cornerRadius = 10
    }

    private var onButtonTapped: (() -> Void)?

    func configure(
        attributedTitle: NSAttributedString,
        backgroundColor: UIColor?,
        onButtonTapped: (() -> Void)? = nil
    ) {
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = backgroundColor
        self.onButtonTapped = onButtonTapped
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        button.addAction(UIAction(handler: { [weak self] _ in
            guard let onButtonTapped = self?.onButtonTapped else { return }
            onButtonTapped()
        }), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
