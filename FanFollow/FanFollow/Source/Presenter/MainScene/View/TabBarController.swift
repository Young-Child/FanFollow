//
//  TabBarController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class TabBarController: UITabBarController {
    private let routers = Router.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let controllers = routers.map(\.instance)
        setViewControllers(controllers, animated: true)
    }
}

private extension TabBarController {
    enum Router: Int, CaseIterable {
        case home
        case chatting
        case explore
        case setting
        
        private var iconName: String {
            switch self {
            case .home:     return "rectangle.stack"
            case .chatting: return "bubble.left.and.bubble.right"
            case .explore:  return "binoculars"
            case .setting:  return "gearshape.2"
            }
        }
        
        private var name: String {
            switch self {
            case .home:     return "피드"
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
            default:
                let rootViewController = UIViewController()
                rootViewController.title = name
                let controller = UINavigationController(rootViewController: rootViewController)
                controller.tabBarItem = tabBarItem
                
                return controller
            }
        }
    }
}
