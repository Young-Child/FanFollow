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
    
    case category = 0
    case links = 1
    case introduce = 2
    
    var title: String {
        switch self {
        case .category:     return "직군 선택"
        case .links:        return "링크 설정"
        case .introduce:    return "소개 설정"
        default:            return ""
        }
    }
    
    var next: Self {
        switch self {
        case .back:
            return .category
        case .category:
            return .links
        case .links:
            return .introduce
        case .introduce, .confirm:
            return .confirm
        }
    }

    var previous: Self {
        switch self {
        case .back, .category:
            return .back
        case .links:
            return .category
        case .introduce, .confirm:
            return .links
        }
    }
    
    var controller: CreatorApplicationChildController? {
        switch self {
        case .category:     return CreatorJobCategoryPickerViewController()
        case .links:        return CreatorLinksTableViewController()
        case .introduce:    return CreatorIntroduceViewController()
        default:            return nil
        }
    }
    
    static var allCases: [CreatorApplicationStep] {
        return [.category, .links, .introduce]
    }
    
    static var allInstance: [CreatorApplicationChildController] {
        return allCases.compactMap { $0.controller }
    }
}
