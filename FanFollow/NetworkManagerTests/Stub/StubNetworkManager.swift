//
//  StubNetworkManager.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

@testable import FanFollow

final class StubNetworkManager: Network {
    private let response: URLResponse
    private let data: Data
    private let error: Error?
    
    init(response: URLResponse, data: Data, error: Error? = nil) {
        self.response = response
        self.data = data
        self.error = error
    }
    
    func response(_ request: URLRequest) -> Observable<(response: URLResponse, data: Data)> {
        if let error = error {
            return Observable.error(error)
        } else {
            return Observable.just((response, data))
        }
    }
    
    func data(_ request: URLRequest) -> Observable<Data> {
        return response(request).map(\.data)
    }
    
    func execute(_ request: URLRequest) -> Completable {
        return response(request).ignoreElements().asCompletable()
    }
}
