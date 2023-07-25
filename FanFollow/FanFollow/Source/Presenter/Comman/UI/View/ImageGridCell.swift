//
//  ImageGridCell.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import SnapKit

final class ImageGridCell: UICollectionViewCell {
    // View Properties
    private let imageView = UIImageView().then { imageView in
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    // Properties
    var identifier: String?
    
    // Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    // Configure Method
    func setImage(to image: UIImage?) {
        self.imageView.image = image
    }
}

// Configure UI Method
private extension ImageGridCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
