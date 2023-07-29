//
//  Bundle+Extension.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/03.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "SupabaseInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["API_KEY"] as? String else {
            fatalError("SupabaseInfo.plist에 API_KEY 설정을 해주세요.")
        }
        return key
    }
}
