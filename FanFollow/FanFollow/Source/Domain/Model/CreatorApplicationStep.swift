//
//  CreatorApplicationStep.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/31.
//

import UIKit

enum CreatorApplicationStep: Int, CaseIterable {
    case category
    case links
    case introduce
    
    var next: Self {
        switch self {
        case .category:
            return .links
        case .links:
            return .introduce
        case .introduce:
            return .introduce
        }
    }

    var previous: Self {
        switch self {
        case .category:
            return .category
        case .links:
            return .category
        case .introduce:
            return .links
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .category:     return CreatorJobCategoryPickerViewController()
        case .links:        return CreatorLinksTableViewController()
        case .introduce:    return CreatorIntroduceViewController()
        }
    }
    
    static var allCases: [CreatorApplicationStep] {
        return [.category, .links, .introduce]
    }
    
    static var allInstance: [UIViewController] {
        return allCases.map { $0.controller }
    }
}
