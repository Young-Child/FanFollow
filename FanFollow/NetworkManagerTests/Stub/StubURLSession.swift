//
//  StubURLSession.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

@testable import FanFollow

class StubURLSession<T: MockDataType>: URLSessionType {
    private var mock: T
    private var isSuccess: Bool
    private var sessionDataTask: MockURLSessionDataTask?
    
    init(mock: T, isSuccess: Bool = true) {
        self.mock = mock
        self.isSuccess = isSuccess
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskType {
        let successResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: "2",
            headerFields: nil
        )
        
        let failureResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 404,
            httpVersion: "2",
            headerFields: nil
        )
        
        let dataTask = MockURLSessionDataTask { [weak self] in
            guard let self = self else { return }
            
            if self.isSuccess {
                completionHandler(mock.sampleData, successResponse, nil)
            } else {
                completionHandler(nil, failureResponse, NetworkError.unknown)
            }
        }
        
        self.sessionDataTask = dataTask
        
        return dataTask
    }
}
