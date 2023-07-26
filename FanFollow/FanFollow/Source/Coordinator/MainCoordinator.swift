//
//  MainCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print(#fileID, #function, #line, "Deinit")
    }
    
    func start() {
        presentMainView(authKey: "")
    }
    
    func presentMainView(authKey: String) {
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}

class TabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinators = Router.allCases.map { $0.generateCoordinator() }
        
        coordinators.forEach { $0.start() }
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = coordinators.map(\.navigationController)
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func present(to controller: UIViewController) {
        navigationController.pushViewController(controller, animated: true)
    }
}

extension TabBarCoordinator {
    enum Router: Int, CaseIterable {
        case feed
        case chatting
        case explore
        case setting
        
        private var iconName: String {
            switch self {
            case .feed:     return "rectangle.stack"
            case .chatting: return "bubble.left.and.bubble.right"
            case .explore:  return "binoculars"
            case .setting:  return "gearshape.2"
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
        }
        
        var instance: UIViewController {
            // TODO: - 각 컨트롤러 구성 후 변경
            switch self {
            case .setting:
                let controller = SettingTabBarController()
                controller.tabBarItem = tabBarItem
                return controller
            case .explore:
                let controller = ExploreTabBarController()
                controller.tabBarItem = tabBarItem
                return controller
            default:
                let rootViewController = UIViewController()
                rootViewController.title = name
                let controller = UINavigationController(rootViewController: rootViewController)
                controller.tabBarItem = tabBarItem
                
                return controller
            }
        }
        
        func generateCoordinator() -> Coordinator {
            switch self {
            case .setting:
                let navigation = UINavigationController()
                return SettingCoordinator(navigationController: navigation)
            default:
                return SettingCoordinator(navigationController: UINavigationController())
            }
        }
    }
}

class SettingCoordinator: Coordinator {
    weak var parentCoordinator: TabBarCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SettingTabBarController()
        controller.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape.2"), tag: 0)
        controller.coordinator = self
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentSettingViewController() {
        let controller = UIViewController()
        controller.hidesBottomBarWhenPushed = true
        parentCoordinator?.navigationController.pushViewController(controller, animated: true)
    }
}
