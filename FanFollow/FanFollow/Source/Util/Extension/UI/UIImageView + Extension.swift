//
//  UIImageView + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

extension UIImageView {
    enum CustomCacheKey: String {
        case profile
    }
    
    func setImageProfileImage(to urlPath: String) {
        self.kf.indicatorType = .activity
        
        let options: KingfisherOptionsInfo = [
            .cacheMemoryOnly,
            .cacheOriginalImage
        ]
        
        setImageWithCustomCacheKey(to: urlPath, key: .profile, options: options)
    }
    
    private func setImageWithCustomCacheKey(
        to urlPath: String,
        key: CustomCacheKey,
        options: KingfisherOptionsInfo
    ) {
        
        
        guard let imageURL = URL(string: urlPath) else { return }
        
        let resource = ImageResource(downloadURL: imageURL, cacheKey: key.rawValue)
        
        kf.setImage(with: resource, options: options)
    }
}

extension ImageCache {
    func changeMemoryImage(to image: KFCrossPlatformImage, key: String) {
        memoryStorage.remove(forKey: key)
        memoryStorage.store(value: image, forKey: key)
    }
}
