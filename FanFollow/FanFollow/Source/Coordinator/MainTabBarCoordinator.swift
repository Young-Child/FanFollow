//
//  MainTabBarCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class MainTabBarCoordinator: Coordinator {
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
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func present(to controller: UIViewController) {
        navigationController.pushViewController(controller, animated: true)
    }
}

private extension MainTabBarCoordinator {
    enum Router: Int, CaseIterable {
        case feed
        case chatting
        case explore
        case setting
        
        private var iconName: String {
            switch self {
            case .feed:     return "newspaper"
            case .chatting: return "bubble.left.and.bubble.right"
            case .explore:  return "binoculars"
            case .setting:  return "gearshape.2"
            }
        }
        
        private var selectedIconName: String {
            switch self {
            case .feed:     return "newspaper.fill"
            case .chatting: return "bubble.left.and.bubble.right.fill"
            case .explore:  return "binoculars.fill"
            case .setting:  return "gearshape.2.fill"
            }
        }
        
        private var name: String {
            switch self {
            case .feed:     return "피드"
            case .chatting: return "채팅"
            case .explore:  return "탐색"
            case .setting:  return "더보기"
            }
        }
        
        private var tabBarItem: UITabBarItem {
            return UITabBarItem(
                title: name,
                image: UIImage(systemName: iconName),
                tag: rawValue
            )
            .then {
                $0.selectedImage = UIImage(systemName: selectedIconName)
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
