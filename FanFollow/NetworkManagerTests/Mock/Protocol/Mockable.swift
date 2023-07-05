//
//  Mockable.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol Mockable {
    var data: Data { get }
    var mock: [Self] { get }
}
