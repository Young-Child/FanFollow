//
//  JSONDecoder+Extension.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/24.
//

import Foundation

extension JSONDecoder {
    static let ISODecoder = {
        let decoder = JSONDecoder()
        let formatter = dateFormatter(formatOptions: [.withInternetDateTime, .withFractionalSeconds])

        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            return formatter.date(from: dateString) ?? Date()
        })
        return decoder
    }()
    
    private static func dateFormatter(formatOptions: ISO8601DateFormatter.Options) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter().then { formatter in
            formatter.formatOptions = formatOptions
        }
        return formatter
    }
}
