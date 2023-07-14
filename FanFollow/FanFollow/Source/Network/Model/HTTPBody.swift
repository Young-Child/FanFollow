//
//  HTTPBody.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum HTTPBody {
    case json(values: [String: Any?])
    case multipart(data: Data)
}
