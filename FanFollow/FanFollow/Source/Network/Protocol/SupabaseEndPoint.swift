//
//  Service.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

protocol EndPoint {
    var baseURL: String { get }
}

protocol SupabaseEndPoint: EndPoint {
    var builder: URLRequestBuilder { get }
}

extension SupabaseEndPoint {
    var baseURL: String {
        return "https://qacasllvaxvrtwbkiavx.supabase.co"
    }
    
    var builder: URLRequestBuilder {
        return URLRequestBuilder(baseURL: URL(staticString: baseURL))
    }
}
