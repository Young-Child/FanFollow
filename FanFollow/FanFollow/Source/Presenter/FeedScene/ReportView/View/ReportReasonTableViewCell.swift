//
//  ReportReasonTableViewCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/31.
//

import UIKit

final class ReportReasonTableViewCell: UITableViewCell {
    // View Properties
    private let reasonLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = Constants.Color.label
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    private let chevronImageView = UIImageView().then {
        $0.tintColor = Constants.Color.gray
        $0.image = Constants.Image.next
    }
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UI Method
extension ReportReasonTableViewCell {
    func configureCell(reason: String) {
        reasonLabel.text = reason
    }
}

// Configure UI
private extension ReportReasonTableViewCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [reasonLabel].forEach { contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        reasonLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
            $0.centerY.equalToSuperview()
        }
    }
}
