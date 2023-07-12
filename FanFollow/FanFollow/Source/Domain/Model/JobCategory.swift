//
//  JobCategory.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation

enum JobCategory {
    case IT
    case art
    case plan
    case media
    case design
    case medical
    case marketing
    case education
    case financial
    
    var categoryName: String {
        switch self {
        case .IT:           return "IT"
        case .art:          return "예술"
        case .plan:         return "기획"
        case .media:        return "미디어"
        case .design:       return "디자인"
        case .medical:      return "의료"
        case .marketing:    return "마케팅"
        case .education:    return "교육"
        case .financial:    return "금융"
        }
    }
}
