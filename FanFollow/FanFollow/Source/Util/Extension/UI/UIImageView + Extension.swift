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

    func setImageKF(
        to url: String,
        onSuccess: ((UIImageView) -> Void)? = nil,
        onFailure: ((UIImageView) -> Void)? = nil
    ) {
        guard let url = URL(string: url) else {
            onFailure?(self)
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                self.image = value.image
                onSuccess?(self)
            case .failure:
                onFailure?(self)
            }
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
