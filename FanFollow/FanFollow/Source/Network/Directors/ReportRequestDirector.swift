//
//  ReportRequestDirector.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/30.
//

import Foundation

struct ReportRequestDirector {
    private let builder: URLRequestBuilder

    init(builder: URLRequestBuilder) {
        self.builder = builder
    }

    func requestUpsertReport(
        reporterID: String,
        banID: String,
        isContent: Bool,
        reason: String
    ) -> URLRequest {
        return builder
            .set(method: .post)
            .set(path: SupabaseConstants.Constants.path)
            .set(headers: [
                SupabaseConstants.Base.apikey: Bundle.main.apiKey,
                SupabaseConstants.Base.contentType: SupabaseConstants.Base.json,
                SupabaseConstants.Base.prefer: SupabaseConstants.Constants.resolutionMergeDuplicates
            ])
            .set(body: [
                SupabaseConstants.Constants.reporterID: reporterID,
                SupabaseConstants.Constants.banID: banID,
                SupabaseConstants.Constants.isContent: isContent,
                SupabaseConstants.Constants.reason: reason
            ])
            .setAccessKey()
            .build()
    }
}

private extension SupabaseConstants {
    enum Constants {
        static let path = Base.basePath + "REPORT"
        static let resolutionMergeDuplicates = "resolution=merge-duplicates"
        static let reporterID = "reporter_id"
        static let banID = "ban_id"
        static let isContent = "is_content"
        static let reason = "reason"
    }
}
