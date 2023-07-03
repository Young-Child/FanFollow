//
//  URLRequestBuilder.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

final class URLRequestBuilder {
    var baseURL: URL
    var path: String = ""
    var queryItems: [String: String] = [:]
    var method: HTTPMethod = .get
    var headers: [String: Any]?
    var body: [String: Any]?
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    @discardableResult
    func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    func set(queryItems: [String: String]) -> Self {
        self.queryItems = queryItems
        return self
    }
    
    @discardableResult
    func set(headers: [String: Any]?) -> Self {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func set(body: [String: Any]?) -> Self {
        self.body = body
        return self
    }
    
    func build() -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.path = path
        let queries = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        components?.queryItems = queries
        
        guard let url = components?.url else {
            return URLRequest(url: baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        headers?.forEach {
            urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key)
        }
        
        if let body = body {
            let bodyData = try? JSONSerialization.data(withJSONObject: body)
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
}
