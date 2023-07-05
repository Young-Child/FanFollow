//
//  MockURLSessionDataTask.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
