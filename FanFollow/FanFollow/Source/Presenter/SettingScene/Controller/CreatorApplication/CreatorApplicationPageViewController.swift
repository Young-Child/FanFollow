//
//  CreatorApplicationPageViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

import RxSwift

//final class CreatorApplicationPageViewController: UIPageViewController {
//    private let creatorJobCategoryPickerViewController = CreatorJobCategoryPickerViewController()
//    private let creatorLinksTableViewController = CreatorLinksTableViewController()
//    private let creatorIntroduceViewController = CreatorIntroduceViewController()
//    private(set) var currentStep: CreatorApplicationStep?
//
//    var updatedJobCategoryIndex: Observable<Int> {
//        return creatorJobCategoryPickerViewController.updatedJobCategoryIndex
//    }
//
//    var updatedLinks: Observable<[String]> {
//        return creatorLinksTableViewController.updatedLinks
//    }
//
//    var updatedIntroduce: Observable<String> {
//        return creatorIntroduceViewController.updatedIntroduce
//            .map { $0 ?? "" }
//    }
//
//    func setViewController(for creatorApplicationStep: CreatorApplicationStep, direction: NavigationDirection) {
//        self.currentStep = creatorApplicationStep
//        let viewController: UIViewController
//        switch creatorApplicationStep {
//        case .category:
//            viewController = creatorJobCategoryPickerViewController
//        case .links:
//            viewController = creatorLinksTableViewController
//        case .introduce:
//            viewController = creatorIntroduceViewController
//        default:
//            return
//        }
//        setViewControllers([viewController], direction: direction, animated: false)
//    }
//}
