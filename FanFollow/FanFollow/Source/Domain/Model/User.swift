//
//  User.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation

protocol User {
    var id: String { get set }
    var nickName: String { get set }
    var isCreator: Bool { get set }
}

extension User {
    var profilePath: String {
        return "ProfileImage/\(id)/profileImage.png"
    }
    
    var profileURL: String {
        return "https://qacasllvaxvrtwbkiavx.supabase.co/storage/v1/object/" + profilePath
    }
}
