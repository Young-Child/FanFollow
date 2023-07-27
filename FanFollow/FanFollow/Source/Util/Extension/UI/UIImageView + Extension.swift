//
//  UIImageView + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

extension UIImageView {
    enum CustomCacheKey {
        case profile
        case post(path: String)
        
        var description: String {
            switch self {
            case .profile:
                return "profile"
            case .post(let path):
                return path
            }
        }
    }
    
    func setImageProfileImage(to urlPath: String) {
        self.kf.indicatorType = .activity
        
        let options: KingfisherOptionsInfo = [
            .cacheMemoryOnly,
            .cacheOriginalImage
        ]
        
        setImageWithCustomCacheKey(to: urlPath, key: .profile, options: options)
    }
    
    func setImagePostImage(
        to urlPath: String,
        key: String,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        self.kf.indicatorType = .activity
        
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage
        ]
        
        setImageWithCustomCacheKey(
            to: urlPath,
            key: .post(path: key),
            options: options,
            completion: completion
        )
    }
    
    private func setImageWithCustomCacheKey(
        to urlPath: String,
        key: CustomCacheKey,
        options: KingfisherOptionsInfo,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        guard let imageURL = URL(string: urlPath) else { return }
        
        let resource = ImageResource(downloadURL: imageURL, cacheKey: key.description)
        
        kf.setImage(with: resource, options: options, completionHandler: completion)
    }
}

extension ImageCache {
    func changeMemoryImage(to image: KFCrossPlatformImage, key: String) {
        memoryStorage.remove(forKey: key)
        memoryStorage.store(value: image, forKey: key)
    }
}
