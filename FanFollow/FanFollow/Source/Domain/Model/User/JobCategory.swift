//
//  JobCategory.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation

enum JobCategory: Int, CaseIterable {
    case art
    case design
    case education
    case financial
    case IT
    case media
    case medical
    case marketing
    case plan
    
    var categoryName: String {
        switch self {
        case .art:          return "예술"
        case .design:       return "디자인"
        case .education:    return "교육"
        case .financial:    return "금융"
        case .IT:           return "IT"
        case .media:        return "미디어"
        case .medical:      return "의료"
        case .marketing:    return "마케팅"
        case .plan:         return "기획"
        }
    }
}
