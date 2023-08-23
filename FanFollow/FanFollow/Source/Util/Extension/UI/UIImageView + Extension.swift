//
//  UIImageView + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

extension UIImageView {
    enum CustomCacheKey {
        case profile(userID: String)
        case post(path: String)
        
        var description: String {
            switch self {
            case .profile(let userID):
                return "profile_\(userID)"
            case .post(let path):
                return path
            }
        }
    }
    
    func setImageProfileImage(to urlPath: String, for userID: String) {
        self.kf.indicatorType = .activity
        
        let failureImage = UIImage(named: "defaultProfile")
        
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .onFailureImage(failureImage)
        ]
        
        setImageWithCustomCacheKey(to: urlPath, key: .profile(userID: userID), options: options)
    }
    
    func setImagePostImage(
        to urlPath: String,
        key: String,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        self.kf.indicatorType = .activity
        
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .cacheMemoryOnly
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
    
    func changeMemoryImage(to imageData: Data, key: String) {
        guard let image = UIImage(data: imageData) else { return }
        
        memoryStorage.remove(forKey: key)
        try? diskStorage.remove(forKey: key)
        memoryStorage.store(value: image, forKey: key)
    }
    
    func removeImageForKey(to key: String) {
        memoryStorage.remove(forKey: key)
    }
}
