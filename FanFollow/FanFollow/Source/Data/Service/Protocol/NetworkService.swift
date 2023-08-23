//
//  NetworkService.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol NetworkService {
    func response(_ request: URLRequest) -> Observable<(response: URLResponse, data: Data)>
    func data(_ request: URLRequest) -> Observable<Data>
    func execute(_ request: URLRequest) -> Completable
}
