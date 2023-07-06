//
//  MockURLSessionDataTask.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

class MockURLSessionDataTask: URLSessionDataTaskType {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
    
    func cancel() { }
}
