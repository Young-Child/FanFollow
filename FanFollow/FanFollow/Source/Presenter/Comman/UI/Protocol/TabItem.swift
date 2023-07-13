//
//  TabItem.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol TabItem: CaseIterable {
    var description: String { get }
    var viewController: UIViewController { get }
}
