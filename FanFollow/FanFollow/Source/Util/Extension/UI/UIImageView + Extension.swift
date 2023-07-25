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
        key: String,
        failureImage: UIImage?,
        round: RoundCase = .none
    ) {
        self.kf.indicatorType = .activity
        
        guard let imageURL = URL(string: url) else {
            self.image = failureImage
            return
        }
        
        let resource = ImageResource(downloadURL: imageURL, cacheKey: key)
        
        setImage(to: resource, failureImage: failureImage, round: round)
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
    
    private func setImage(to resource: Resource, failureImage: UIImage?, round: RoundCase) {
        self.kf.cancelDownloadTask()
        
        var options = KingfisherOptionsInfo()
        options.append(.onFailureImage(failureImage))
        
        switch round {
        case .round(let radius):
            let roundProcessor = RoundCornerImageProcessor(cornerRadius: CGFloat(radius))
            options.append(.processor(roundProcessor))
        case .none:
            break
        }
        
        self.kf.setImage(with: resource, options: options) { result in
            switch result {
            case .success(let image):
                ImageCache.default.memoryStorage.store(
                    value: image.image,
                    forKey: resource.cacheKey
                )
                
            case .failure:
                break
            }
        }
    }
}
