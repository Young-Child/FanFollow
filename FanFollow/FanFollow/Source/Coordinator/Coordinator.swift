//
//  Coordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    
    func removeChild(to child: Coordinator?)
    func close(to controller: UIViewController)
}

extension Coordinator {
    func removeChild(to child: Coordinator?) {
        guard let child = child,
              let parentCoordinator = parentCoordinator else { return }
        parentCoordinator.childCoordinators.removeAll(where: { $0 === child })
    }
    
    func close(to controller: UIViewController) {
        removeChild(to: self)
        var controllers = navigationController.viewControllers
        if controller.parent == nil {
            controller.dismiss(animated: true)
            return
        }
        
        controllers.removeAll(where: { $0 === controller })
        
        guard let lastController = controllers.last else { return }
        navigationController.popToViewController(lastController, animated: true)
    }
}
