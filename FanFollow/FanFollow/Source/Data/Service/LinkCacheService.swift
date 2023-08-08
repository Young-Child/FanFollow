//
//  LinkCacheService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import LinkPresentation

final class LinkCacheService {
    static func cache(metaData: LPLinkMetadata) {
        do {
            guard let url = metaData.url?.absoluteString,
                  retrieve(url: url) == nil else { return }
            
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: metaData,
                requiringSecureCoding: true
            )
            
            UserDefaults.standard.setValue(data, forKey: url)
        } catch let error {
            print("Error when Caching Metadata \(error.localizedDescription)")
        }
    }
    
    static func retrieve(url: String) -> LPLinkMetadata? {
        do {
            guard let data = UserDefaults.standard.object(forKey: url) as? Data,
                  let metaData = try NSKeyedUnarchiver.unarchivedObject(
                    ofClass: LPLinkMetadata.self,
                    from: data
                  ) else {
                return nil
            }
            
            return metaData
        } catch {
            return nil
        }
    }
}
