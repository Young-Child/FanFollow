//
//  BlockUserViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class BlockUserViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 차단"
        label.textColor = Constants.Color.label
        label.font = .coreDreamFont(ofSize: 24, weight: .extraBold)
        return label
    }()
    
    private let informationLabels: [UILabel] = {
        let labels = (0..<3).map { _ in
            let label = UILabel()
            label.textColor = Constants.Color.grayDark
            label.font = .coreDreamFont(ofSize: 16, weight: .medium)
            return label
        }
        
        return labels
    }()
    
    private let labelStackView = UIStackView().then {
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let blockButton = UIButton().then {
        $0.setTitle("차단", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.backgroundColor = Constants.Color.warningColor?.cgColor
        $0.layer.cornerRadius = 4
    }
    
    private var informations: [String] = [
        "사용자의 게시물이 노출되지 않습니다.",
        "사용자가 노출되지 않습니다.",
        "설정에서 차단을 해제할 수 있습니다."
    ]
    
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
            item.text = informations[safe: index]
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Constants.Spacing.medium)
        }
    }
}
