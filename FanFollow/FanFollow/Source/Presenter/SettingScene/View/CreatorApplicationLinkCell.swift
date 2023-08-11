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
    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let textField = UnderLineTextField().then { textField in
        textField.textColor = UIColor(named: "AccentColor")
        textField.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        textField.text = nil
    }
    
    func configure(index: Int, link: String? = nil) {
        titleLabel.text = "링크 \(index + 1)"
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
        [titleLabel, textField].forEach(contentView.addSubview(_:))
    }
    
    func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(8)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).inset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
    }
}
