//
//  Service.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

protocol Service {
    var baseURL: String { get }
}

protocol SupabaseService: Service {
    var builder: URLRequestBuilder { get }
}

extension SupabaseService {
    var baseURL: String {
        return "https://miaytxhuzztromylqmou.supabase.co"
    }
    
    var builder: URLRequestBuilder {
        return URLRequestBuilder(baseURL: URL(staticString: baseURL))
    }
}
