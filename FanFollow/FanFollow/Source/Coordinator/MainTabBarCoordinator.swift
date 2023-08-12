//
//  MainTabBarCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class MainTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinators = Router.allCases.map(\.coordinator)
        let controllers = coordinators.map(\.navigationController)
        
        coordinators.forEach {
            $0.start()
            childCoordinators.append($0)
        }
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(controllers, animated: true)
        
        // TabBar Appearance Setting
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemGray6
        tabBarController.tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func present(to controller: UIViewController) {
        navigationController.pushViewController(controller, animated: true)
    }
}

private extension MainTabBarCoordinator {
    enum Router: Int, CaseIterable {
        case feed
        case explore
        case setting
        
        private var icon: UIImage? {
            switch self {
            case .feed:     return Constants.Image.feed
            case .explore:  return Constants.Image.explore
            case .setting:  return Constants.Image.setting
            }
        }
        
        private var selectedIcon: UIImage? {
            switch self {
            case .feed:     return Constants.Image.feedFill
            case .explore:  return Constants.Image.exploreFill
            case .setting:  return Constants.Image.settingFill
            }
        }
        
        private var name: String {
            switch self {
            case .feed:     return "피드"
            case .explore:  return "탐색"
            case .setting:  return "더보기"
            }
        }
        
        private var tabBarItem: UITabBarItem {
            return UITabBarItem(title: name, image: icon, tag: rawValue)
                .then {
                    $0.selectedImage = selectedIcon
                }
        }
        
        var coordinator: Coordinator {
            let navigationController = UINavigationController()
            navigationController.tabBarItem = tabBarItem
            
            switch self {
            case .feed:
                return FeedCoordinator(navigationController: navigationController)
            case .setting:
                return SettingCoordinator(navigationController: navigationController)
            case .explore:
                return ExploreCoordinator(navigationController: navigationController)
            default:
                return SettingCoordinator(navigationController: navigationController)
            }
        }
    }
}
