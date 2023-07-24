//
//  Date+Extension.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/24.
//

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()

    func toString(format: String) -> String? {
        let formatter = Self.dateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
