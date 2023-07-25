//
//  ImageGridCell.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import SnapKit

final class ImageGridCell: UICollectionViewCell {
    private let imageView = UIImageView().then { imageView in
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    var identifier: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    func setImage(to image: UIImage?) {
        self.imageView.image = image
    }
}

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
