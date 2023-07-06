//
//  SupabaseConstants.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

enum SupabaseConstants {
    enum Base {
        // PATH
        static let basePath = "/rest/v1/"
        
        // QUERY
        static let select = "select"
        static let selectAll = "*"
        static let count = "count"
        static let equal = "eq."
        static let `is` = "is."
        static let or = "or."
        
        // HEADER
        static let apikey = "apikey"
        static let authorization = "Authorization"
        static let bearer = "Bearer "
        static let range = "Range"
        static let contentType = "Content-Type"
        static let json = "application/json"
        static let prefer = "Prefer"
    }
}
