//
//  StubUserDefaultsService.swift
//  RepositoryTests
//
//  Created by junho lee on 2023/08/08.
//

import Foundation

@testable import FanFollow

final class StubUserDefaultsService: UserDefaultsService {
    var data = [String: Any]()

    func set(_ value: Any?, forKey key: String) {
        data[key] = value
    }

    func object(forKey key: String) -> Any? {
        return data[key]
    }

    func removeObject(forKey key: String) {
        data[key] = nil
    }
}
