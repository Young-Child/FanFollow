//
//  StubURLSession.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

@testable import FanFollow

class StubURLSession: URLSessionType {
    typealias Response = (data: Data?, response: URLResponse?, error: Error?)
    
    private let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskType {
        return MockURLSessionDataTask { [weak self] in
            guard let self = self else {
                completionHandler(nil, nil, nil)
                return
            }
            
            completionHandler(
                self.response.data,
                self.response.response,
                self.response.error
            )
        }
    }
}

extension StubURLSession {
    static func make(url: String, mock: MockData, statusCode: Int) -> StubURLSession {
        let stubURLSession: StubURLSession = {
            let response = HTTPURLResponse(
                url: URL(string: url)!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
            
            let mockResponse: Response = (
                data: mock.sampleData,
                response: response,
                error: statusCode == 200 ? nil : NetworkError.unknown
            )
            
            let session = StubURLSession(response: mockResponse)
            return session
        }()
        
        return stubURLSession
    }
}
