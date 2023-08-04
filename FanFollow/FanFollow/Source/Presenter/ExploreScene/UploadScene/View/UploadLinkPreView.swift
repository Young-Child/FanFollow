//
//  UploadLinkPreView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/03.
//

import UIKit

final class UploadLinkPreView: UIView {
    private let defaultImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(systemName: "link")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UploadLinkPreView {
    func configureUI() {
        backgroundColor = .systemGray5
        
        configureHierarchy()
        makeConstraints()
        configureLayer()
    }
    
    func configureHierarchy() {
        addSubview(defaultImageView)
    }
    
    func configureLayer() {
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        clipsToBounds = true
    }
    
    func makeConstraints() {
        defaultImageView.snp.makeConstraints {
            $0.height.width.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
