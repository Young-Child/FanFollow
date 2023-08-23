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
    var headers: [String: Any] = [:]
    var body: HTTPBody?
    
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
    func set(headers: [String: Any]) -> Self {
        headers.forEach {
            self.headers[$0.key] = $0.value
        }
        return self
    }
    
    func setAccessKey() -> Self {
        guard let token = UserDefaults.storedSession()?.accessToken else {
            return self
        }
        
        self.headers[SupabaseConstants.Base.authorization] = SupabaseConstants.Base.bearer + token
        return self
    }
    
    @discardableResult
    func set(body: [String: Any?]) -> Self {
        self.body = .json(values: body)
        return self
    }
    
    @discardableResult
    func set(body: HTTPBody) -> Self {
        self.body = body
        return self
    }
    
    func build() -> URLRequest {
        var request = generateURLRequest()
        
        switch body {
        case let .json(values):
            let bodyData = try? JSONSerialization.data(withJSONObject: values)
            request.httpBody = bodyData
            
        case let .multipart(data):
            request.httpBody = data
            
        default: break
        }
        
        return request
    }
    
    private func generateURLRequest() -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.path = path
        let queries = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        components?.queryItems = queries
        
        guard let url = components?.url else {
            return URLRequest(url: baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        headers.forEach {
            if let value = $0.value as? String {
                urlRequest.addValue(value, forHTTPHeaderField: $0.key)
            }
        }
        
        return urlRequest
    }
}

extension UserDefaults {
    static func storedSession() -> StoredSession? {
        guard let data = self.standard.object(forKey: Self.Key.session) as? Data else {
            return nil
        }
        
        return try? JSONDecoder().decode(StoredSession.self, from: data)
    }
}
