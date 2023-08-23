//
//  UserDefaultsService.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/08.
//

import Foundation

protocol UserDefaultsService {
    func set(_ value: Any?, forKey: String)
    func object(forKey: String) -> Any?
    func removeObject(forKey: String)
}

extension UserDefaults: UserDefaultsService { }
