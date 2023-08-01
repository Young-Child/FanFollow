//
//  LinkPreview.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import LinkPresentation

import SnapKit

final class LinkPreview: UIView {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.numberOfLines = 2
    }
    
    private let urlLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.numberOfLines = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLayout()
    }
    
    func setData(meta: LPLinkMetadata) {
        titleLabel.text = meta.title
        urlLabel.text = meta.originalURL?.absoluteString
        
        meta.imageProvider?.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    let path = UIBezierPath(
                        roundedRect: self.imageView.bounds,
                        byRoundingCorners: [.topRight, .bottomRight],
                        cornerRadii: CGSize(width: 12, height: 12)
                    )
                    let mask = CAShapeLayer().then {
                        $0.path = path.cgPath
                    }
                    self.imageView.layer.mask = mask
                    self.imageView.image = image
                    
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    func resetData() {
        titleLabel.text = nil
        urlLabel.text = nil
        imageView.image = nil
    }
    
    private func configureLayout() {
        backgroundColor = UIColor.systemGray5
        layer.cornerRadius = 12
        
        [imageView, titleLabel, urlLabel].forEach(addSubview(_:))
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalTo(imageView.snp.leading).offset(-16)
        }
        
        urlLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
}
