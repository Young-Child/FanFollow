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
}

struct ReportReason {
    var title: String
}

extension ReportReason {
    private static var commonReasons: [Self] {
        return [
            .init(title: "스팸"),
            .init(title: "나체 이미지 또는 성적 행위"),
            .init(title: "사기 또는 거짓"),
            .init(title: "혐오 발언 또는 상징"),
            .init(title: "거짓 정보"),
            .init(title: "저작권 침해")
        ]
    }
    
    static func reasons(reportType: ReportType) -> [Self] {
        var commonReason = self.commonReasons
        
        switch reportType {
        case .content:
            commonReason.insert(.init(title: "마음에 들지 않습니다. (숨김 처리)"), at: .zero)
        case .user:
            commonReason.insert(.init(title: "사칭"), at: .zero)
        }
        
        return commonReason
    }
}
