//
//  CreatorApplicationTextFieldCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

protocol CreatorApplicationLinkCellDelegate: AnyObject {
    func creatorApplicationTextFieldCell(
        _ cell: CreatorApplicationLinkCell,
        didChangeText changedText: (index: Int, text: String?)
    )
}

final class CreatorApplicationLinkCell: UITableViewCell {
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
    
    weak var delegate: CreatorApplicationLinkCellDelegate?
    
    private var onTextChanged: ((Int, String?) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(index: Int, link: String? = nil) {
        titleLabel.text = "링크 \(index)"
        textField.text = link
        
        let textChangeAction = UIAction { _ in
            self.delegate?.creatorApplicationTextFieldCell(
                self,
                didChangeText: (index, self.textField.text)
            )
        }
        
        textField.addAction(textChangeAction, for: .editingChanged)
    }
}

private extension CreatorApplicationLinkCell {
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
