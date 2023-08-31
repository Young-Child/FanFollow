//
//  ReportType.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/31.
//

import Foundation

enum ReportType {
    case content
    case user
    
    var title: String {
        switch self {
        case .content:
            return "게시물을 "
        case .user:
            return "사용자를 "
        }
    }
}

struct ReportReason {
    var reason: String
}

extension ReportReason {
    private static var commonReasons: [Self] {
        return [
            .init(reason: "스팸"),
            .init(reason: "나체 이미지 또는 성적 행위"),
            .init(reason: "사기 또는 거짓"),
            .init(reason: "혐오 발언 또는 상징"),
            .init(reason: "거짓 정보"),
            .init(reason: "저작권 침해")
        ]
    }
    
    static func reasons(reportType: ReportType) -> [Self] {
        var commonReason = self.commonReasons
        
        switch reportType {
        case .content:
            commonReason.insert(.init(reason: "마음에 들지 않습니다. (숨김 처리)"), at: .zero)
        case .user:
            commonReason.insert(.init(reason: "사칭"), at: .zero)
        }
        
        return commonReason
    }
}
