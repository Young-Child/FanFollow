//
//  URLSessionType.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol URLSessionType {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskType
}
