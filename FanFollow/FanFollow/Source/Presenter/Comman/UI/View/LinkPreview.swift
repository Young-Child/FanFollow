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
        $0.font = .coreDreamFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 2
    }
    
    private let urlLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 12, weight: .light)
        $0.numberOfLines = 1
    }
    
    private let loadingView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Constants.Color.blue
        $0.startAnimating()
    }
    
    private let contentView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLayout()
    }
    
    func setData(meta: LPLinkMetadata) {
        loadingView.startAnimating()
        loadingView.isHidden = false
        
        meta.imageProvider?.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self.configureRoundingImageView(with: image)
                    self.titleLabel.text = meta.title
                    self.urlLabel.text = meta.originalURL?.absoluteString
                    self.loadingView.stopAnimating()
                }
            }
        }
    }
    
    private func configureRoundingImageView(with image: UIImage) {
        let width = Constants.Spacing.small
        let path = UIBezierPath(
            roundedRect: self.imageView.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: width, height: width)
        )
        
        let mask = CAShapeLayer().then { $0.path = path.cgPath }
        
        self.imageView.layer.mask = mask
        self.imageView.image = image
    }
    
    func resetData() {
        titleLabel.text = nil
        urlLabel.text = nil
        imageView.image = nil
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    private func configureLayout() {
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = Constants.Color.gray
        
        [imageView, titleLabel, urlLabel, loadingView].forEach(contentView.addSubview(_:))
        addSubview(contentView)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.top.equalToSuperview().offset(Constants.Spacing.small)
            $0.trailing.equalTo(imageView.snp.leading).offset(-Constants.Spacing.medium)
        }
        
        urlLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.small)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        loadingView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Spacing.small)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.small)
            $0.top.bottom.equalToSuperview()
        }
    }
}
