//
//  MainTabBarCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

final class MainTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setKingFisherModifier()
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
        appearance.backgroundColor = Constants.Color.background
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        tabBarController.tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func present(to controller: UIViewController) {
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func setKingFisherModifier() {
        guard let accessToken = UserDefaults.storedSession()?.accessToken else { return }
        
        let modifier = AnyModifier { request in
            var request = request
            
            request.setValue(Bundle.main.apiKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return request
        }
        
        KingfisherManager.shared.defaultOptions = [.requestModifier(modifier)]
        
        ImageCache.default.clearDiskCache()
        ImageCache.default.diskStorage.config.expiration = .seconds(15)
        ImageCache.default.memoryStorage.config.expiration = .seconds(15)
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
            case .feed:     return Constants.Text.feed
            case .explore:  return Constants.Text.explore
            case .setting:  return Constants.Text.setting
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
            navigationController.navigationBar.isHidden = true
            navigationController.tabBarItem = tabBarItem
            
            switch self {
            case .feed:
                return FeedCoordinator(navigationController: navigationController)
            case .setting:
                return SettingCoordinator(navigationController: navigationController)
            case .explore:
                return ExploreCoordinator(navigationController: navigationController)
            }
        }
    }
}
