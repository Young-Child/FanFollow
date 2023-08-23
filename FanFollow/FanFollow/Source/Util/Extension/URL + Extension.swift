//
//  URL+Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension URL {
    init(staticString: String) {
        guard let url = URL(string: staticString) else {
            preconditionFailure("Could Not Convert URL with \(staticString)")
        }
        
        self = url
    }
}
