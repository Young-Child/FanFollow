//
//  BlockUserViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class BlockUserViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.blockUserTitle
        label.textColor = Constants.Color.label
        label.font = .coreDreamFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let informationLabels: [UILabel] = {
        let labels = (0..<3).map { _ in
            let label = UILabel()
            label.textColor = Constants.Color.grayDark
            label.font = .coreDreamFont(ofSize: 14, weight: .regular)
            return label
        }
        
        return labels
    }()
    
    private let labelStackView = UIStackView().then {
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.axis = .vertical
        $0.spacing = Constants.Spacing.small
    }
    
    private let blockButton = UIButton().then {
        $0.setTitle(Constants.Text.block, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.backgroundColor = Constants.Color.warningColor?.cgColor
        $0.layer.cornerRadius = 4
    }
    
    private var informations: [String] = Constants.Text.blockUserInformations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

private extension BlockUserViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        informationLabels.enumerated().forEach { index, item in
            item.text = Constants.Text.blockUserInformations[safe: index]
            labelStackView.addArrangedSubview(item)
        }
        
        [titleLabel, labelStackView, blockButton].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(Constants.Spacing.medium)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
        
        blockButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .offset(-Constants.Spacing.medium)
        }
    }
}
