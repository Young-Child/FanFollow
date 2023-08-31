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
        label.font = .coreDreamFont(ofSize: 32, weight: .extraBold)
        return label
    }()
    
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
        [titleLabel].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(8)
        }
    }
}
