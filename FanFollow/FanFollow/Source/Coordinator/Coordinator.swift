//
//  Coordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    
    func close(to child: Coordinator)
}

extension Coordinator {
    func close(to child: Coordinator) {
        for (index, childCoordinator) in childCoordinators.enumerated() {
            if childCoordinator === child {
                childCoordinators.remove(at: index)
            }
        }
    }
}
