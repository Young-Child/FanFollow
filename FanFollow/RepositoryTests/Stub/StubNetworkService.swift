//
//  StubNetworkManager.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/06.
//

import Foundation
import RxSwift

@testable import FanFollow

final class StubNetworkService: NetworkService {
    var data: Data?
    var error: Error?
    var response: URLResponse?

    init(data: Data? = nil, error: Error? = nil, response: URLResponse? = nil) {
        self.data = data
        self.error = error
        self.response = response
    }

    func response(_ request: URLRequest) -> Observable<(response: URLResponse, data: Data)> {
        if let error {
            return Observable.error(error)
        }

        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            return Observable.error(NetworkError.unknown)
        }

        guard let data else {
            return Observable.error(NetworkError.unknown)
        }

        return Observable.just((response, data))
    }

    func data(_ request: URLRequest) -> Observable<Data> {
        return response(request).map(\.data)
    }

    func execute(_ request: URLRequest) -> Completable {
        return response(request).ignoreElements().asCompletable()
    }
}
