//
//  UIImageView + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

extension UIImageView {
    enum RoundCase {
        case none
        case round(cornerRadius: Int)
    }
    
    func setImageKF(
        to url: String,
        failureImage: UIImage,
        round: RoundCase = .none
    ) {
        self.kf.indicatorType = .activity
        
        guard let imageURL = URL(string: url) else {
            self.image = failureImage
            return
        }
        
        setImage(to: imageURL, failureImage: failureImage, round: round)
    }

    func setImageKF(to url: String, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) {
        self.kf.indicatorType = .activity

        guard let url = URL(string: url) else {
            return
        }

        kf.setImage(with: url, placeholder: nil, options: nil) { result in
            completionHandler?(result)
        }
    }

    private func setImage(to url: URL, failureImage: UIImage, round: RoundCase) {
        var options = KingfisherOptionsInfo()
        
        switch round {
        case .round(let radius):
            let roundProcessor = RoundCornerImageProcessor(cornerRadius: CGFloat(radius))
            options.append(.processor(roundProcessor))
        case .none:
            break
        }
        
        self.kf.setImage(with: url, options: options)
    }
}
