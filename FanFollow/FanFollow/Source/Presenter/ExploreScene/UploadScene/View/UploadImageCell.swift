//
//  UploadImageCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

final class UploadImageCell: UICollectionViewCell {
    // View Property
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: Data) {
        imageView.image = UIImage(data: data)
    }
}

// Configure UI
private extension UploadImageCell {
    func configureUI() {
        backgroundColor = .white
        
        configureLayer()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureLayer() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(contentView)
        }
    }
}
