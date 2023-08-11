//
//  Array + Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
