//
//  CreatorApplicationStep.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/31.
//

import UIKit

enum CreatorApplicationStep: Int, CaseIterable {
    case back = -1
    case confirm = -2
    
    case agreement = 0
    case category = 1
    case links = 2
    case introduce = 3
    
    var title: String {
        switch self {
        case .agreement:     return "이용 약관 동의"
        case .category:     return "직군 선택"
        case .links:        return "링크 설정"
        case .introduce:    return "소개 설정"
        default:            return ""
        }
    }
    
    var next: Self {
        switch self {
        case .back:                     return .agreement
        case .agreement:                return .category
        case .category:                 return .links
        case .links:                    return .introduce
        case .introduce, .confirm:      return .confirm
        }
    }

    var previous: Self {
        switch self {
        case .back, .agreement:         return .back
        case .category:                 return .agreement
        case .links:                    return .category
        case .introduce, .confirm:      return .links
        }
    }
    
    var controller: CreatorApplicationChildController? {
        switch self {
        case .agreement:    return CreatorAgreementViewController()
        case .category:     return CreatorJobCategoryPickerViewController()
        case .links:        return CreatorLinksTableViewController()
        case .introduce:    return CreatorIntroduceViewController()
        default:            return nil
        }
    }
    
    static var allCases: [CreatorApplicationStep] {
        return [.agreement, .category, .links, .introduce]
    }
    
    static var allInstance: [CreatorApplicationChildController] {
        return allCases.compactMap { $0.controller }
    }
}
