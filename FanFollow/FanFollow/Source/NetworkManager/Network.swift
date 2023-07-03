//
//  Network.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

protocol Network {
    @discardableResult
    func execute(_ request: URLRequest) -> Observable<Data>
}
