//
//  NetworkManager.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class NetworkManager: Network {
    func execute(_ request: URLRequest) -> Observable<Data> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...300) ~= response.statusCode else {
                    emitter.onError(NetworkError.unknown)
                    return
                }
                
                guard let data = data else {
                    emitter.onError(NetworkError.unknown)
                    return
                }
                
                emitter.onNext(data)
                emitter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
