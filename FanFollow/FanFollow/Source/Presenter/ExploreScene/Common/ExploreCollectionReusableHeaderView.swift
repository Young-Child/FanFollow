//
//  ExploreCollectionReusableHeaderView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

final class ExploreCollectionReusableHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
}

// Configure UI
private extension ExploreCollectionReusableHeaderView {
    private func configureUI() {
        backgroundColor = .clear
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
